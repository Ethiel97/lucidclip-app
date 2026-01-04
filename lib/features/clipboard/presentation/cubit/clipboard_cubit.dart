import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'clipboard_state.dart';

@lazySingleton
class ClipboardCubit extends HydratedCubit<ClipboardState> {
  ClipboardCubit({
    required this.clipboardManager,
    required this.clipboardRepository,
    required this.localClipboardRepository,
    required this.localClipboardHistoryRepository,
    required this.localSettingsRepository,
  }) : super(const ClipboardState()) {
    _loadData();
    _startWatchingClipboard();
    _watchSettings();
  }

  Future<void> _loadData() async {
    await Future.wait([
      // loadClipboardItems(),
      _loadLocalClipboardItems(),
      // loadClipboardHistory(),
      loadTags(),
    ]);
  }

  final BaseClipboardManager clipboardManager;
  final ClipboardRepository clipboardRepository;
  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardHistoryRepository localClipboardHistoryRepository;
  final LocalSettingsRepository localSettingsRepository;

  StreamSubscription<ClipboardData>? _clipboardSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;
  StreamSubscription<ClipboardHistories>? _localHistorySubscription;
  StreamSubscription<UserSettings?>? _userSettingsSubscription;

  UserSettings? _userSettings;

  // TODO(Ethiel97): Placeholder for userId until auth context is available
  static const String _pendingUserId = '';

  void _watchSettings() {
    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = localSettingsRepository
        .watchSettings(_pendingUserId.isEmpty ? 'guest' : _pendingUserId)
        .listen((s) {
          _userSettings = s;
        });
  }

  void _startWatchingClipboard() {
    _clipboardSubscription = clipboardManager.watchClipboard().listen((
      clipboardData,
    ) async {
      final settings = _userSettings;

      if (settings?.incognitoMode ?? false) {
        // In incognito mode, do not store clipboard data
        developer.log(
          'Incognito mode is enabled; skipping clipboard storage.',
          name: 'ClipboardCubit',
        );
        return;
      }

      //excluded apps check
      final excluded = settings?.excludedApps ?? const <String>[];
      final bundleId = clipboardData.sourceApp?.bundleId;

      if (bundleId != null &&
          bundleId.isNotEmpty &&
          excluded.contains(bundleId)) {
        return;
      }

      final currentItems = state.clipboardItems.data;

      final isDuplicate = currentItems.any(
        (item) => item.contentHash == clipboardData.contentHash,
      );

      if (!isDuplicate) {
        // Convert ClipboardData to ClipboardItem and upsert to local repository
        final clipboardItem = clipboardData.toDomain(userId: _pendingUserId);
        await _upsertClipboardItem(clipboardItem);

        // Create clipboard history record
        await _createClipboardHistory(clipboardItem.id);
      }
    });
  }

  Future<void> _upsertClipboardItem(ClipboardItem item) async {
    try {
      await localClipboardRepository.upsert(item);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to upsert clipboard item to local repository',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // The item is still added to the in-memory list
    }
  }

  Future<void> _createClipboardHistory(String clipboardItemId) async {
    try {
      final history = ClipboardHistory(
        id: IdGenerator.generate(),
        clipboardItemId: clipboardItemId,
        action: ClipboardAction.copy,
        userId: _pendingUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Store history locally
      await localClipboardHistoryRepository.upsert(history);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to create clipboard history record',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // Continue working even if history creation fails
    }
  }

  Future<void> _loadLocalClipboardItems() async {
    _localItemsSubscription = localClipboardRepository.watchAll().listen(
      (items) {
        emit(state.copyWith(clipboardItems: items.toSuccess()));
      },
      onError: (Object error, StackTrace stackTrace) {
        emit(
          state.copyWith(
            clipboardItems: state.clipboardItems.toError(
              ErrorDetails(
                message: 'Error watching local clipboard items: $error',
              ),
            ),
          ),
        );
        developer.log(
          'Error watching local clipboard items',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );

    // Watch local clipboard history stream
    _localHistorySubscription = localClipboardHistoryRepository
        .watchAll()
        .listen(
          (histories) {
            // Store histories in state if needed

            emit(state.copyWith(clipboardHistory: histories.toSuccess()));

            /*developer.log(
          'Received ${histories.length} clipboard history records from stream',
          name: 'ClipboardCubit',
        );*/
          },
          onError: (Object error, StackTrace stackTrace) {
            emit(
              state.copyWith(
                clipboardHistory: state.clipboardHistory.toError(
                  ErrorDetails(
                    message: 'Error watching local clipboard history: $error',
                  ),
                ),
              ),
            );
            developer.log(
              'Error watching local clipboard history',
              error: error,
              stackTrace: stackTrace,

              name: 'ClipboardCubit',
            );
          },
        );
  }

  Future<void> loadClipboardItems() async {
    try {
      emit(state.copyWith(clipboardItems: state.clipboardItems.toLoading()));
    } on ServerException {
      emit(
        state.copyWith(
          clipboardItems: state.clipboardItems.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading clipboard items.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          clipboardItems: state.clipboardItems.toError(
            ErrorDetails(
              message: 'An error occurred while loading clipboard items: $e',
            ),
          ),
        ),
      );
    }
  }

  /*  Future<void> loadClipboardHistory() async {
    try {
      if (state.clipboardHistory.isLoading) {
        return;
      }

      emit(
        state.copyWith(clipboardHistory: state.clipboardHistory.toLoading()),
      );

      final data = await clipboardRepository.fetchClipboardHistory();

      emit(state.copyWith(clipboardHistory: data.toSuccess()));
    } on ServerException {
      emit(
        state.copyWith(
          clipboardHistory: state.clipboardHistory.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading clipboard history.',
            ),
          ),
        ),
      );
    }
  }*/

  // load tags
  Future<void> loadTags() async {
    try {
      if (state.tags.isLoading) {
        return;
      }
      emit(state.copyWith(tags: state.tags.toLoading()));

      final data = await clipboardRepository.fetchTags();
      emit(state.copyWith(tags: data.toSuccess()));
    } on ServerException {
      emit(
        state.copyWith(
          tags: state.tags.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading tags.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          tags: state.tags.toError(
            ErrorDetails(message: 'An error occurred while loading tags: $e'),
          ),
        ),
      );
    }
  }

  // load clipboard item tags
  Future<void> loadClipboardItemTags() async {
    try {
      if (state.clipboardItemTags.isLoading) {
        return;
      }
      emit(
        state.copyWith(clipboardItemTags: state.clipboardItemTags.toLoading()),
      );
      final data = await clipboardRepository.fetchClipboardItemTags();
      emit(state.copyWith(clipboardItemTags: data.toSuccess()));
    } on ServerException {
      emit(
        state.copyWith(
          clipboardItemTags: state.clipboardItemTags.toError(
            const ErrorDetails(
              message:
                  'Server error occurred while loading clipboard item tags.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          clipboardItemTags: state.clipboardItemTags.toError(
            ErrorDetails(
              message:
                  'An error occurred while loading clipboard item tags: $e',
            ),
          ),
        ),
      );
    }
  }

  @override
  ClipboardState? fromJson(Map<String, dynamic> json) {
    try {
      return ClipboardState.fromJson(json);
    } catch (_) {
      return const ClipboardState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ClipboardState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await _clipboardSubscription?.cancel();
    await clipboardManager.dispose();
    await _localHistorySubscription?.cancel();
    await _localItemsSubscription?.cancel();
    return super.close();
  }
}

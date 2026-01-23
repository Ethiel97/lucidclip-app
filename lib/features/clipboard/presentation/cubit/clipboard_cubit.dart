import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'clipboard_state.dart';

@lazySingleton
class ClipboardCubit extends HydratedCubit<ClipboardState> {
  ClipboardCubit({
    required this.authRepository,
    required this.clipboardManager,
    required this.clipboardRepository,
    required this.localClipboardRepository,
    required this.localClipboardHistoryRepository,
    required this.localSettingsRepository,
    required this.remoteSettingsRepository,
    required this.retentionCleanupService,
  }) : super(const ClipboardState()) {
    _initializeAuthListener();
    _loadData();
    _startWatchingClipboard();
    _startPeriodicCleanup();
  }

  Future<void> _loadData() async {
    await Future.wait([
      // loadClipboardItems(),
      _loadLocalClipboardItems(),
      // loadClipboardHistory(),
      loadTags(),
    ]);
  }

  /// Performs cleanup of expired items (non-blocking)
  void _performCleanup() {
    // Run cleanup without blocking the UI
    retentionCleanupService.cleanupExpiredItems().catchError(
      (Object error, StackTrace stackTrace) => developer.log(
        'Failed to perform cleanup on refresh',
        error: error,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      ),
    );
  }

  /// Starts periodic cleanup of expired items
  /// Runs every hour to ensure the database doesn't get full
  void _startPeriodicCleanup() {
    // Run cleanup every hour
    const cleanupInterval = Duration(hours: 2);

    _periodicCleanupTimer?.cancel();

    _periodicCleanupTimer = Timer.periodic(cleanupInterval, (_) {
      developer.log('Running periodic cleanup', name: 'ClipboardCubit');
      _performCleanup();
    });
  }

  final BaseClipboardManager clipboardManager;
  final AuthRepository authRepository;
  final ClipboardRepository clipboardRepository;
  final LocalClipboardHistoryRepository localClipboardHistoryRepository;
  final LocalClipboardRepository localClipboardRepository;
  final LocalSettingsRepository localSettingsRepository;
  final SettingsRepository remoteSettingsRepository;
  final RetentionCleanupService retentionCleanupService;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<ClipboardData>? _clipboardSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;
  StreamSubscription<ClipboardHistories>? _localHistorySubscription;
  StreamSubscription<UserSettings?>? _userSettingsSubscription;
  Timer? _periodicCleanupTimer;

  UserSettings? _userSettings;

  String _currentUserId = 'guest';

  bool get isAuthenticated => _currentUserId != 'guest';

  void _initializeAuthListener() {
    _authSubscription = authRepository.authStateChanges.listen((user) {
      _currentUserId = user?.id ?? 'guest';

      _watchSettings();
    });
  }

  void _watchSettings() {
    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = localSettingsRepository
        .watchSettings(_currentUserId)
        .listen((s) {
          developer.log(
            'Watching settings: $s from clipboard cubit',
            name: 'ClipboardCubit',
          );
          _userSettings = s;
        });
  }

  void _startWatchingClipboard() {
    _clipboardSubscription = clipboardManager.watchClipboard().listen((
      clipboardData,
    ) async {
      final settings = _userSettings;

      developer.log(
        'incognito mode: ${settings?.incognitoMode}',
        name: 'ClipboardCubit',
      );

      if (settings?.incognitoMode ?? false) {
        developer.log(
          'Incognito mode is enabled; skipping clipboard storage.',
          name: 'ClipboardCubit',
        );
        return;
      }

      //excluded apps check
      final excluded = settings?.excludedApps ?? const <SourceApp>[];
      final sourceApp = clipboardData.sourceApp;

      developer.log('Excluded apps: $excluded', name: 'ClipboardCubit');

      if (_isSourceAppExcluded(sourceApp)) {
        developer.log(
          'Clipboard data from excluded app (${sourceApp?.bundleId}); '
          'skipping storage.',
          name: 'ClipboardCubit',
        );
        return;
      }

      final currentItems = state.clipboardItems.data;

      final isDuplicate = currentItems.any(
        (item) => item.contentHash == clipboardData.contentHash,
      );

      final now = DateTime.now().toUtc();

      // TODO(Ethiel97): Check duplicate content update

      if (isDuplicate) {
        developer.log('Duplicate detected; bumping lastUsedAt.');

        final candidates = currentItems.where(
          (i) => i.contentHash == clipboardData.contentHash,
        );
        final existingItem = candidates.reduce((a, b) {
          final aToSort = a.lastUsedAt ?? a.createdAt;
          final bToSort = b.lastUsedAt ?? b.createdAt;
          return aToSort.isAfter(bToSort) ? a : b;
        });

        final last = existingItem.lastUsedAt ?? existingItem.createdAt;
        const cooldown = Duration(seconds: 3);
        final shouldLogHistory = now.difference(last) > cooldown;

        final updatedItem = existingItem.copyWith(
          lastUsedAt: now,
          usageCount: (existingItem.usageCount) + 1,
        );

        await _upsertClipboardItem(updatedItem);

        if (shouldLogHistory) {
          await _createClipboardHistory(updatedItem.id);
        }
      } else {
        final newItem = clipboardData
            .toDomain(userId: _currentUserId)
            .copyWith(
              lastUsedAt: now, // optionnel mais cohérent
            );

        await _upsertClipboardItem(newItem);
        await _createClipboardHistory(newItem.id);
      }
    });
  }

  bool _isSourceAppExcluded(SourceApp? sourceApp) {
    if (sourceApp == null || !sourceApp.isValid) {
      return false;
    }
    final excludedApps = _userSettings?.excludedApps ?? <SourceApp>[];
    return excludedApps.any(
      (excludedApp) => excludedApp.bundleId == sourceApp.bundleId,
    );
  }

  Future<void> _upsertClipboardItem(ClipboardItem item) async {
    try {
      await localClipboardRepository.upsertWithLimit(
        item: item,
        maxItems: _userSettings?.maxHistoryItems ?? defaultMaxHistoryItems,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to upsert clipboard item to local repository',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
    }
  }

  Future<void> _createClipboardHistory(String clipboardItemId) async {
    try {
      final history = ClipboardHistory(
        id: IdGenerator.generate(),
        clipboardItemId: clipboardItemId,
        action: ClipboardAction.copy,
        userId: _currentUserId,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
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

  Future<void> copyToClipboard(ClipboardItem item) async {
    try {
      //TODO(Ethiel97): Investigate why this is not working as expected
      await clipboardManager.setClipboardContent(item.toInfrastructure());
    } catch (e, stackTrace) {
      developer.log(
        'Failed to copy content to clipboard',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // Handle error if necessary
    }
  }

  Future<void> clearClipboard() {
    return localClipboardRepository.clear();
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
    _periodicCleanupTimer?.cancel();
    await _authSubscription?.cancel();
    await _clipboardSubscription?.cancel();
    await clipboardManager.dispose();
    await _localHistorySubscription?.cancel();
    await _localItemsSubscription?.cancel();
    await _userSettingsSubscription?.cancel();
    return super.close();
  }
}

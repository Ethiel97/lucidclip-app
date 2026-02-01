import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'clipboard_state.dart';

const expiredItemsCleanUpInterval = Duration(hours: 6);

@lazySingleton
class ClipboardCubit extends HydratedCubit<ClipboardState> {
  ClipboardCubit({
    required this.deviceIdProvider,
    required this.authRepository,
    required this.clipboardManager,
    required this.clipboardRepository,
    required this.localClipboardRepository,
    required this.localClipboardOutboxRepository,
    required this.localSettingsRepository,
    required this.remoteSettingsRepository,
    required this.retentionCleanupService,
  }) : super(const ClipboardState()) {
    _boot();
  }

  final BaseClipboardManager clipboardManager;
  final DeviceIdProvider deviceIdProvider;

  final AuthRepository authRepository;
  final ClipboardRepository clipboardRepository;

  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardOutboxRepository localClipboardOutboxRepository;

  final LocalSettingsRepository localSettingsRepository;
  final SettingsRepository remoteSettingsRepository;
  final RetentionCleanupService retentionCleanupService;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<ClipboardData>? _clipboardSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;
  StreamSubscription<UserSettings?>? _userSettingsSubscription;

  late final String _deviceId;
  Timer? _periodicCleanupTimer;

  UserSettings? _userSettings;
  String _currentUserId = 'guest';

  bool get isAuthenticated => _currentUserId != 'guest';

  Future<void> _boot() async {
    await Future.wait([_loadData(), _init()]);
    _initializeAuthListener();
    _startWatchingClipboard();
    _startPeriodicCleanup();
  }

  Future<void> _init() async {
    _deviceId = await deviceIdProvider.getInstallationId();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadLocalClipboardItems(), loadTags()]);
  }

  void _initializeAuthListener() {
    _authSubscription?.cancel();
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

  /// Performs cleanup of expired items (non-blocking)
  void _performCleanup() {
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
  void _startPeriodicCleanup() {
    const cleanupInterval = expiredItemsCleanUpInterval;

    _periodicCleanupTimer?.cancel();
    _periodicCleanupTimer = Timer.periodic(cleanupInterval, (_) {
      developer.log('Running periodic cleanup', name: 'ClipboardCubit');
      _performCleanup();
    });
  }

  void _startWatchingClipboard() {
    _clipboardSubscription?.cancel();
    _clipboardSubscription = clipboardManager.watchClipboard().listen(
      (clipboardData) async {
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

        // Excluded apps check
        final sourceApp = clipboardData.sourceApp;
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
          final shouldEnqueueCopyOp = now.difference(last) > cooldown;

          final updatedItem = existingItem.copyWith(
            lastUsedAt: now,
            usageCount: existingItem.usageCount + 1,
          );

          await _upsertClipboardItem(updatedItem);

          if (shouldEnqueueCopyOp) {
            await _enqueueOutboxCopy(updatedItem.id);
          }
        } else {
          final newItem = clipboardData
              .toDomain(userId: _currentUserId)
              .copyWith(lastUsedAt: now);

          await _upsertClipboardItem(newItem);

          // Enqueue “copy” operation for sync purposes
          await _enqueueOutboxCopy(newItem.id);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'Error watching clipboard stream',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );
  }

  bool _isSourceAppExcluded(SourceApp? sourceApp) {
    if (sourceApp == null || !sourceApp.isValid) return false;
    final excludedApps = _userSettings?.excludedApps ?? <SourceApp>[];
    return excludedApps.any((e) => e.bundleId == sourceApp.bundleId);
  }

  Future<void> _upsertClipboardItem(ClipboardItem item) async {
    try {
      await localClipboardRepository.upsertWithLimit(
        item: item,
        maxItems: _userSettings?.maxHistoryItems ?? MaxHistorySize.size30.value,
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

  Future<void> _enqueueOutboxCopy(String entityId) async {
    try {
      final op = ClipboardOutbox(
        id: IdGenerator.generate(),
        // operationId
        deviceId: _deviceId,
        entityId: entityId,
        operationType: ClipboardOperationType.insert,
        userId: _currentUserId,
        createdAt: DateTime.now().toUtc(),

        // Recommandé si ton modèle le supporte :
        // payload: '{"v":1,"happenedAt":"...","patch":{"deltaUsage":1}}',
        // deviceId: _deviceId,
      );

      await localClipboardOutboxRepository.enqueue(op);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to enqueue outbox operation',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
    }
  }

  Future<void> _loadLocalClipboardItems() async {
    await _localItemsSubscription?.cancel();

    _localItemsSubscription = localClipboardRepository
        .watchAll(
          limit: _userSettings?.maxHistoryItems ?? MaxHistorySize.size30.value,
        )
        .listen(
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
  }

  Future<void> copyToClipboard(ClipboardItem item) async {
    try {
      await clipboardManager.setClipboardContent(item.toInfrastructure());
    } catch (e, stackTrace) {
      developer.log(
        'Failed to copy content to clipboard',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
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

  Future<void> loadTags() async {
    try {
      if (state.tags.isLoading) return;

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

  Future<void> loadClipboardItemTags() async {
    try {
      if (state.clipboardItemTags.isLoading) return;

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
    await _localItemsSubscription?.cancel();
    await _userSettingsSubscription?.cancel();
    return super.close();
  }
}

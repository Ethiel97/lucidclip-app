import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/settings.dart';

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
    required this.retentionCleanupService,
    required this.retentionTracker,
    required this.settingsRepository,
  }) : super(const ClipboardState()) {
    _initialize();
  }

  final BaseClipboardManager clipboardManager;
  final DeviceIdProvider deviceIdProvider;

  final AuthRepository authRepository;
  final ClipboardRepository clipboardRepository;

  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardOutboxRepository localClipboardOutboxRepository;
  final SettingsRepository settingsRepository;

  final RetentionCleanupService retentionCleanupService;
  final RetentionTracker retentionTracker;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<ClipboardData>? _clipboardSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;
  StreamSubscription<UserSettings?>? _userSettingsSubscription;

  late final String _deviceId;
  Timer? _periodicCleanupTimer;

  UserSettings? _userSettings;
  String _currentUserId = 'anonymous';

  final List<ClipboardData> _pendingClipboardEvents = <ClipboardData>[];

  int get _effectiveMaxHistoryItems =>
      _userSettings?.maxHistoryItems ?? MaxHistorySize.size30.value;

  Future<void> _initialize() async {
    await _initDeviceId();
    _startPeriodicCleanup();
    _startClipboardWatcher(); // Start once; gate processing
    // on settings readiness.
    _startAuthWatcher();
  }

  Future<void> _initDeviceId() async {
    _deviceId = await deviceIdProvider.getInstallationId();
  }

  void _startAuthWatcher() {
    _authSubscription?.cancel();
    _authSubscription = authRepository.authStateChanges.listen(
      (user) {
        _currentUserId = (user?.isAnonymous ?? true) ? 'anonymous' : user!.id;
        _startSettingsWatcherForUser(_currentUserId);
      },
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'Auth watcher error',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );
  }

  void _startSettingsWatcherForUser(String userId) {
    _userSettingsSubscription?.cancel();

    _userSettingsSubscription = settingsRepository
        .watchLocal(userId)
        .listen(
          (settings) async {
            final previousMax = _userSettings?.maxHistoryItems;
            _userSettings = settings;

            _ensureLocalItemsSubscription(previousMax: previousMax);

            if (_pendingClipboardEvents.isEmpty) return;

            final pending = List<ClipboardData>.from(_pendingClipboardEvents);
            _pendingClipboardEvents.clear();

            for (final data in pending) {
              await _handleClipboardData(data);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            developer.log(
              'Settings watcher error',
              error: error,
              stackTrace: stackTrace,
              name: 'ClipboardCubit',
            );

            // Still watch items with defaults if settings stream fails.
            _ensureLocalItemsSubscription(previousMax: null);
          },
        );
  }

  void _ensureLocalItemsSubscription({required int? previousMax}) {
    final nextMax = _effectiveMaxHistoryItems;
    if (previousMax == nextMax && _localItemsSubscription != null) return;
    _subscribeLocalItems(limit: nextMax);
  }

  void _subscribeLocalItems({required int limit}) {
    _localItemsSubscription?.cancel();

    _localItemsSubscription = localClipboardRepository
        .watchAll(limit: limit)
        .listen(
          (items) {
            emit(state.copyWith(clipboardItems: items.toSuccess()));
          },
          onError: (Object error, StackTrace stackTrace) async {
            emit(
              state.copyWith(
                clipboardItems: state.clipboardItems.toError(
                  ErrorDetails(
                    message: 'Error watching local clipboard items: $error',
                  ),
                ),
              ),
            );

            unawaited(
              Observability.captureException(
                error,
                stackTrace: stackTrace,
                hint: {'operation': 'watch_local_clipboard_items'},
              ),
            );

            unawaited(
              Observability.breadcrumb(
                'Local clipboard watch failed',
                category: 'clipboard',
                level: ObservabilityLevel.error,
              ),
            );
          },
        );
  }

  void _startClipboardWatcher() {
    _clipboardSubscription?.cancel();
    _clipboardSubscription = clipboardManager.watchClipboard().listen(
      (clipboardData) async {
        // Buffer a small backlog until settings arrive at least once.
        if (_userSettings == null) {
          if (_pendingClipboardEvents.length < 50) {
            _pendingClipboardEvents.add(clipboardData);
          }
          return;
        }
        await _handleClipboardData(clipboardData);
      },
      onError: (Object error, StackTrace stackTrace) async {
        await Observability.captureException(
          error,
          stackTrace: stackTrace,
          hint: {'operation': 'watch_clipboard_stream'},
        );
        await Observability.breadcrumb(
          'Clipboard stream watch failed',
          category: 'clipboard',
          level: ObservabilityLevel.error,
        );
      },
    );
  }

  Future<void> _handleClipboardData(ClipboardData clipboardData) async {
    final settings = _userSettings;

    if (settings?.incognitoMode ?? false) {
      developer.log(
        'Incognito mode enabled; skipping clipboard storage.',
        name: 'ClipboardCubit',
      );
      return;
    }

    final sourceApp = clipboardData.sourceApp;
    if (_isSourceAppExcluded(sourceApp)) {
      developer.log(
        'Excluded source app (${sourceApp?.bundleId}); skipping storage.',
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

        // Track clipboard item used (duplicate/re-copy)
        await Analytics.track(AnalyticsEvent.clipboardItemUsed);
      }
      return;
    }

    final newItem = clipboardData
        .toDomain(userId: _currentUserId)
        .copyWith(lastUsedAt: now);

    await _upsertClipboardItem(newItem);
    await _enqueueOutboxCopy(newItem.id);

    // Track clipboard item captured (new item)
    await Analytics.track(AnalyticsEvent.clipboardItemCaptured);

    // Track first clipboard capture
    final isFirstCapture = await retentionTracker.isFirstClipboardCapture();
    if (isFirstCapture) {
      await Analytics.track(AnalyticsEvent.clipboardFirstItemCaptured);
    }
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
        maxItems: _effectiveMaxHistoryItems,
      );
    } catch (e, stackTrace) {
      unawaited(
        Observability.captureException(
          e,
          stackTrace: stackTrace,
          hint: {
            'operation': 'upsert_clipboard_item',
            'item_count': state.clipboardItems.value?.length ?? 0,
          },
        ),
      );
    }
  }

  Future<void> _enqueueOutboxCopy(String entityId) async {
    try {
      final op = ClipboardOutbox(
        id: IdGenerator.generate(),
        deviceId: _deviceId,
        entityId: entityId,
        operationType: ClipboardOperationType.insert,
        userId: _currentUserId,
        createdAt: DateTime.now().toUtc(),
      );

      await localClipboardOutboxRepository.enqueue(op);
    } catch (e, stackTrace) {
      unawaited(
        Observability.captureException(
          e,
          stackTrace: stackTrace,
          hint: {'operation': 'enqueue_outbox'},
        ),
      );
    }
  }

  void _performCleanup() {
    retentionCleanupService.cleanupExpiredItems().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      developer.log(
        'Failed to perform cleanup',
        error: error,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );

      unawaited(
        Observability.captureException(
          error,
          stackTrace: stackTrace,
          hint: {'operation': 'retention periodic_cleanup'},
        ),
      );
    });
  }

  void _startPeriodicCleanup() {
    _periodicCleanupTimer?.cancel();
    _periodicCleanupTimer = Timer.periodic(expiredItemsCleanUpInterval, (_) {
      developer.log('Running periodic cleanup', name: 'ClipboardCubit');
      _performCleanup();
    });
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
    _pendingClipboardEvents.clear();
    await _authSubscription?.cancel();
    await _userSettingsSubscription?.cancel();
    await _localItemsSubscription?.cancel();
    await _clipboardSubscription?.cancel();
    await clipboardManager.dispose();
    return super.close();
  }
}

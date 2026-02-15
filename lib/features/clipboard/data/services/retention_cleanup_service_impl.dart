import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

@LazySingleton(as: RetentionCleanupService)
class RetentionCleanupServiceImpl implements RetentionCleanupService {
  RetentionCleanupServiceImpl({
    required this.localClipboardRepository,
    required this.settingsRepository,
    required this.authRepository,
  });

  final LocalClipboardRepository localClipboardRepository;
  final SettingsRepository settingsRepository;
  final AuthRepository authRepository;

  @override
  Future<void> cleanupExpiredItems() async {
    try {
      // Get current user
      final user = await authRepository.getCurrentUser();
      final userId = user?.id ?? 'anonymous';

      final settings = await settingsRepository.load(userId);
      final retentionDays = settings?.retentionDays ?? defaultRetentionDays;

      final retentionDuration = RetentionDuration.fromDays(retentionDays);

      // Create retention expiration policy
      final policy = RetentionExpirationPolicy(
        now: DateTime.now,
        retentionDuration: retentionDuration,
      );

      // Calculate cutoff date - items created before this date may be expired
      final cutoffDate = DateTime.now().subtract(retentionDuration.duration);

      // Get only items that could potentially be expired
      // This is much more efficient than fetching all items
      final items = await localClipboardRepository.getPotentiallyExpiredItems(
        cutoffDate: cutoffDate,
      );

      // Evaluate and delete expired items
      var deletedCount = 0;
      for (final item in items) {
        // Evaluate retention expiration
        try {
          final expiration = policy.evaluate(item: item);

          // If item has expired, delete it
          if (expiration.isExpired) {
            await localClipboardRepository.delete(item.id);
            deletedCount++;

            // Track item auto-deleted due to retention
            Analytics.track(
              AnalyticsEvent.itemAutoDeleted,
              const ItemAutoDeletedParams(
                reason: DeletionReason.retention,
              ).toMap(),
            ).unawaited();

            developer.log(
              'Deleted expired clipboard item: ${item.id}',
              name: 'RetentionCleanupService',
            );
          }
        } catch (e, stack) {
          Observability.captureException(
            e,
            stackTrace: stack,
            hint: {'operation': 'evaluateRetention'},
          ).unawaited();

          developer.log(
            'Failed to evaluate retention for item ${item.id}: $e',
            name: 'RetentionCleanupService',
            stackTrace: stack,
          );
          // Continue with next item
          continue;
        }
      }

      if (deletedCount > 0) {
        developer.log(
          'Cleanup completed: $deletedCount item(s) deleted',
          name: 'RetentionCleanupService',
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Failed to cleanup expired clipboard items',
        error: e,
        stackTrace: stackTrace,
        name: 'RetentionCleanupService',
      );
      // Swallow error to prevent disrupting app flow
    }
  }
}

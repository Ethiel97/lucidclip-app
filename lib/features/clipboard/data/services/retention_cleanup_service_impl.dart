import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
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
      final userId = user?.id ?? 'guest';

      final settings = await settingsRepository.load(userId);
      final retentionDays = settings?.retentionDays ?? defaultRetentionDays;

      final retentionDuration = RetentionDuration.fromDays(retentionDays);

      // Get all clipboard items
      final items = await localClipboardRepository.getAll(
        fetchMode: FetchMode.withoutIcons,
      );

      // Create retention expiration policy
      final policy = RetentionExpirationPolicy(
        now: DateTime.now,
        retentionDuration: retentionDuration,
      );

      // Evaluate and delete expired items
      var deletedCount = 0;
      for (final item in items) {
        // Never delete pinned or snippet items
        if (item.isPinned || item.isSnippet) {
          continue;
        }

        // Evaluate retention expiration
        try {
          final expiration = policy.evaluate(item: item);

          // If item has expired, delete it
          if (expiration.isExpired) {
            await localClipboardRepository.delete(item.id);
            deletedCount++;

            // Track item auto-deleted due to retention
            await Analytics.track(
              AnalyticsEvent.itemAutoDeleted,
              const ItemAutoDeletedParams(
                reason: DeletionReason.retention,
              ).toMap(),
            );

            developer.log(
              'Deleted expired clipboard item: ${item.id}',
              name: 'RetentionCleanupService',
            );
          }
        } catch (e, stack) {
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

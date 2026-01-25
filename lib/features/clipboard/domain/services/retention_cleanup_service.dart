/// Service responsible for automatically removing expired clipboard items
/// based on retention policies.
///
/// This service evaluates all clipboard items against the configured retention
/// duration and removes items that have exceeded their retention period.
/// It respects pinned and snippet items which are never auto-deleted.
/// ignore: one_member_abstracts
abstract class RetentionCleanupService {
  /// Performs cleanup of expired clipboard items.
  ///
  /// This method:
  /// - Retrieves the current user's entitlement status (Pro/Free)
  /// - Fetches retention settings (from user settings for Pro, defaults for Free)
  /// - Evaluates all clipboard items against retention policy
  /// - Removes expired items (excluding pinned and snippet items)
  ///
  /// This method is idempotent and safe to call multiple times.
  Future<void> cleanupExpiredItems();
}

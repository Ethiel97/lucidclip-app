/// Abstract feedback service interface for collecting user feedback.
///
/// Implementations should:
/// - Provide a way to show feedback UI
/// - Support custom metadata (non-PII)
/// - Handle feedback submission
abstract class FeedbackService {
  /// Show the feedback UI to the user
  Future<void> show();

  /// Set custom metadata for feedback context
  /// Note: Should only use anonymous/hashed identifiers, never PII
  Future<void> setMetadata(Map<String, dynamic> metadata);

  /// Clear all metadata
  Future<void> clearMetadata();
}

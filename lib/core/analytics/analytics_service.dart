/// Abstract analytics service interface for LucidClip.
/// This interface defines the contract for all analytics implementations.
library;

/// Abstract analytics service for tracking events.
///
/// Implementations should:
/// - Track events with name and optional parameters
/// - Respect privacy: NO clipboard content, text, or PII
/// - Support environment-based enabling (disabled in dev, enabled in prod/staging)
abstract class AnalyticsService {
  /// Track an event with optional parameters
  ///
  /// [eventName] - The name of the event to track
  /// [parameters] - Optional parameters for the event (must not contain PII)
  Future<void> track(String eventName, [Map<String, Object>? parameters]);

  /// Identify a user (if applicable)
  /// Note: Should only use anonymous/hashed identifiers, never PII
  Future<void> identify(String userId);

  /// Clear user identification
  Future<void> clearIdentity();

  /// Whether analytics is enabled in the current environment
  bool get isEnabled;
}

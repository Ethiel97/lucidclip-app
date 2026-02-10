/// Severity level for log messages and breadcrumbs.
enum ObservabilityLevel {
  /// Debug-level information (verbose)
  debug,

  /// Informational messages
  info,

  /// Warning messages
  warning,

  /// Error messages
  error,

  /// Fatal/critical errors
  fatal,
}

/// Service contract for application observability (errors, breadcrumbs, logs).
///
/// This interface defines the contract for error tracking and logging
/// capabilities. It should be implemented by concrete observability
/// providers like Sentry.
abstract class ObservabilityService {
  /// Whether observability tracking is enabled.
  ///
  /// Returns `true` if the service is active and will send data,
  /// `false` otherwise (e.g., in development/debug mode).
  bool get isEnabled;

  /// Captures an exception with optional stack trace and hint.
  ///
  /// Use this to manually report caught exceptions or errors.
  ///
  /// Parameters:
  /// - [exception]: The exception or error object to capture
  /// - [stackTrace]: Optional stack trace for the exception
  /// - [hint]: Optional map of additional context (key-value pairs)
  ///
  /// Returns a Future that completes when the error is reported.
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  });

  /// Adds a breadcrumb for debugging context.
  ///
  /// Breadcrumbs are a trail of events that happened before an error.
  /// They help understand the user journey leading up to an issue.
  ///
  /// Parameters:
  /// - [message]: Human-readable breadcrumb message
  /// - [category]: Optional category (e.g., 'navigation', 'user_action', 'http')
  /// - [data]: Optional additional structured data
  /// - [level]: Severity level
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    ObservabilityLevel level = ObservabilityLevel.info,
  });

  /// Sets user information for tracking.
  ///
  /// This information is attached to all subsequent events.
  /// Should only include non-PII data by default.
  ///
  /// Parameters:
  /// - [userId]: Unique user identifier
  /// - [email]: Optional user email (use with caution for privacy)
  /// - [extras]: Optional additional user properties
  Future<void> setUser(
    String userId, {
    String? email,
    Map<String, String>? extras,
  });

  /// Clears user information.
  ///
  /// Call this on logout to remove user context from events.
  Future<void> clearUser();

  /// Sets a custom tag for filtering events.
  ///
  /// Tags are key-value pairs that can be used to filter and
  /// search events in the observability platform.
  ///
  /// Parameters:
  /// - [key]: Tag key
  /// - [value]: Tag value
  Future<void> setTag(String key, String value);

  /// Closes the observability service and flushes pending events.
  ///
  /// Call this before app termination to ensure all events are sent.
  Future<void> close();
}

import 'package:lucid_clip/core/observability/observability_service.dart';

/// Static facade for observability operations.
///
/// This provides a convenient static API for error tracking and logging
/// throughout the application, while delegating to an injectable
/// [ObservabilityService] implementation.
///
/// Usage:
/// ```dart
/// // Initialize once during app startup
/// Observability.initialize(getIt<ObservabilityService>());
///
/// // Use anywhere in the app
/// try {
///   // risky operation
/// } catch (e, st) {
///   await Observability.captureException(e, stackTrace: st);
/// }
///
/// // Add breadcrumbs
/// await Observability.breadcrumb('User navigated to settings');
///
/// // Set user context
/// await Observability.setUser(userId);
/// ```
class Observability {
  Observability._();

  static ObservabilityService? _service;

  /// Initializes the observability facade with a service implementation.
  ///
  /// Must be called once during app startup before using other methods.
  /// ignore: use_setters_to_change_properties
  static void initialize(ObservabilityService service) {
    _service = service;
  }

  /// Whether observability tracking is enabled.
  static bool get isEnabled => _service?.isEnabled ?? false;

  /// Captures an exception with optional stack trace and context.
  ///
  /// Use this to manually report caught exceptions.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (e, st) {
  ///   await Observability.captureException(
  ///     e,
  ///     stackTrace: st,
  ///     hint: {'operation': 'riskyOperation'},
  ///   );
  ///   rethrow;
  /// }
  /// ```
  static Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) async {
    await _service?.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  /// Adds a breadcrumb for debugging context.
  ///
  /// Breadcrumbs create a trail of events leading up to an error.
  ///
  /// Example:
  /// ```dart
  /// await Observability.breadcrumb(
  ///   'Clipboard item captured',
  ///   category: 'clipboard',
  ///   data: {
  ///     'content_type': 'text',
  ///     'content_length': textLength,
  ///   },
  ///   level: ObservabilityLevel.info,
  /// );
  /// ```
  static Future<void> breadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    ObservabilityLevel level = ObservabilityLevel.info,
  }) async {
    await _service?.addBreadcrumb(
      message,
      category: category,
      data: data,
      level: level,
    );
  }

  /// Sets user information for tracking.
  ///
  /// This context is attached to all subsequent events.
  /// Only include userId by default; email is optional and should be
  /// used with caution for privacy.
  ///
  /// Example:
  /// ```dart
  /// await Observability.setUser(user.id);
  /// ```
  static Future<void> setUser(
    String userId, {
    String? email,
    Map<String, String>? extras,
  }) async {
    await _service?.setUser(userId, email: email, extras: extras);
  }

  /// Clears user information.
  ///
  /// Call this on logout to remove user context.
  ///
  /// Example:
  /// ```dart
  /// await Observability.clearUser();
  /// ```
  static Future<void> clearUser() async {
    await _service?.clearUser();
  }

  /// Sets a custom tag for filtering events.
  ///
  /// Tags help organize and filter events in the observability dashboard.
  ///
  /// Example:
  /// ```dart
  /// await Observability.setTag('subscription_tier', 'pro');
  /// ```
  static Future<void> setTag(String key, String value) async {
    await _service?.setTag(key, value);
  }

  /// Closes the observability service and flushes pending events.
  ///
  /// Call this before app termination to ensure all events are sent.
  static Future<void> close() async {
    await _service?.close();
    _service = null;
  }
}

import 'package:lucid_clip/core/analytics/analytics_service.dart';

/// Global analytics singleton entry point.
///
/// This provides a single, convenient access point for tracking analytics
/// events throughout the app.
///
/// Usage:
/// ```dart
/// Analytics.track(AnalyticsEvent.appFirstLaunch);
/// Analytics.track(AnalyticsEvent.freeLimitReached,
/// {'limit_type': 'history_size'});
/// ```
class Analytics {
  Analytics._();

  static AnalyticsService? _instance;

  /// Initialize the analytics service
  // ignore: use_setters_to_change_properties
  static void initialize(AnalyticsService service) => _instance = service;

  /// Track an event with optional parameters
  static Future<void> track(
    String eventName, [
    Map<String, Object>? parameters,
  ]) async {
    await _instance?.track(eventName, parameters);
  }

  /// Identify a user (using anonymous/hashed identifier only)
  static Future<void> identify(String userId) async {
    await _instance?.identify(userId);
  }

  /// Clear user identification
  static Future<void> clearIdentity() async {
    await _instance?.clearIdentity();
  }

  /// Whether analytics is enabled
  static bool get isEnabled => _instance?.isEnabled ?? false;
}

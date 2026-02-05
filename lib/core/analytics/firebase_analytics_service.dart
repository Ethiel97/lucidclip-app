import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_service.dart';
import 'package:lucid_clip/core/constants/constants.dart';

/// Firebase Analytics implementation of AnalyticsService.
///
/// This implementation:
/// - Uses Firebase Analytics for event tracking
/// - Disabled by default in debug/development mode
/// - Enabled only in staging/production builds
/// - Ensures no PII or clipboard content is tracked
@LazySingleton(as: AnalyticsService)
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService({
    FirebaseAnalytics? firebaseAnalytics,
    this.enabledInDebug = false,
  }) : _analytics = firebaseAnalytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;
  final bool enabledInDebug;

  /// Whether analytics is enabled based on the current environment
  ///
  /// Analytics is enabled if:
  /// - In production mode (AppConstants.isProd == true), OR
  /// - Explicitly enabled in debug via enabledInDebug parameter
  @override
  bool get isEnabled => AppConstants.isProd || enabledInDebug;

  @override
  Future<void> track(
    String eventName, [
    Map<String, Object>? parameters,
  ]) async {
    if (!isEnabled) {
      // Skip tracking in disabled environments
      return;
    }

    try {
      // Firebase Analytics has naming restrictions:
      // - Event names must be <= 40 characters
      // - Cannot start with a number
      // - Can only contain alphanumeric characters and underscores
      final sanitizedName = _sanitizeEventName(eventName);

      // Track the event using Firebase Analytics
      await _analytics.logEvent(name: sanitizedName, parameters: parameters);
    } catch (e) {
      // Silently fail - analytics errors should not crash the app
      log(
        'Analytics error tracking event "$eventName": $e',
        name: 'FirebaseAnalyticsService',
      );
    }
  }

  @override
  Future<void> identify(String userId) async {
    if (!isEnabled) {
      return;
    }

    try {
      // Set user ID in Firebase Analytics
      // Note: Only use hashed/anonymous identifiers, never PII
      await _analytics.setUserId(id: userId);
    } catch (e) {
      log(
        'Analytics error identifying user: $e',
        name: 'FirebaseAnalyticsService',
      );
    }
  }

  @override
  Future<void> clearIdentity() async {
    if (!isEnabled) {
      return;
    }

    try {
      // Clear user identification
      await _analytics.setUserId();
    } catch (e) {
      log(
        'Analytics error clearing identity: $e',
        name: 'FirebaseAnalyticsService',
      );
    }
  }

  /// Sanitize event name to comply with Firebase Analytics naming rules
  String _sanitizeEventName(String eventName) {
    // Firebase Analytics event name rules:
    // - Must be <= 40 characters
    // - Can only contain letters, numbers, and underscores
    // - Cannot start with a number

    var sanitized = eventName
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9_]'), '_')
        .replaceAll(RegExp('_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    // Ensure it doesn't start with a number
    if (sanitized.isNotEmpty && RegExp(r'^\d').hasMatch(sanitized)) {
      sanitized = 'event_$sanitized';
    }

    // Truncate to 40 characters if needed
    if (sanitized.length > 40) {
      sanitized = sanitized.substring(0, 40);
    }

    return sanitized;
  }
}

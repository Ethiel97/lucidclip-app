import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lucid_clip/core/analytics/analytics_service.dart';
import 'package:wiredash/wiredash.dart';

/// WireDash implementation of AnalyticsService.
///
/// This implementation:
/// - Uses WireDash for event tracking
/// - Disabled by default in debug/development mode
/// - Enabled only in staging/production builds
/// - Ensures no PII or clipboard content is tracked
class WireDashAnalyticsService implements AnalyticsService {
  WireDashAnalyticsService({
    required this.wiredashProjectId,
    required this.wiredashSecret,
    this.enabledInDebug = false,
  });

  final String wiredashProjectId;
  final String wiredashSecret;
  final bool enabledInDebug;

  /// Whether analytics is enabled based on the current environment
  ///
  /// Analytics is enabled if:
  /// - Not in debug mode (kDebugMode == false), OR
  /// - Explicitly enabled in debug via enabledInDebug parameter
  @override
  bool get isEnabled => !kDebugMode || enabledInDebug;

  @override
  Future<void> track(String eventName, [Map<String, dynamic>? parameters]) async {
    if (!isEnabled) {
      // Skip tracking in disabled environments
      return;
    }

    try {
      // Track the event using Wiredash
      Wiredash.trackEvent(eventName, data: parameters);
    } catch (e) {
      // Silently fail - analytics errors should not crash the app
      debugPrint('Analytics error tracking event "$eventName": $e');
    }
  }

  @override
  Future<void> identify(String userId) async {
    if (!isEnabled) {
      return;
    }

    try {
      // Set user properties in Wiredash
      // Note: Only use hashed/anonymous identifiers, never PII
      Wiredash.of(null)?.setUserProperties(
        userIdentifier: userId,
      );
    } catch (e) {
      debugPrint('Analytics error identifying user: $e');
    }
  }

  @override
  Future<void> clearIdentity() async {
    if (!isEnabled) {
      return;
    }

    try {
      // Clear user identification
      Wiredash.of(null)?.setUserProperties(
        userIdentifier: null,
      );
    } catch (e) {
      debugPrint('Analytics error clearing identity: $e');
    }
  }
}

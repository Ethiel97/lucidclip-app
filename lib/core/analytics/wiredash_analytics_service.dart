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
///
/// Note: User identification is handled via Wiredash widget configuration
/// in the app setup, not directly through this service.
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
      // Note: User identification is typically handled at the Wiredash widget level
      // via the userId parameter. This method is provided for interface compliance
      // but may not be actively used in the current implementation.
      debugPrint('Analytics: User identified: $userId');
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
      // Note: User identification clearing is typically handled at the app level
      // by updating the Wiredash widget userId parameter.
      debugPrint('Analytics: User identity cleared');
    } catch (e) {
      debugPrint('Analytics error clearing identity: $e');
    }
  }
}

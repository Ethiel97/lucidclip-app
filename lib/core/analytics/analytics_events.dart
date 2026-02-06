/// Analytics event names and typed helpers for LucidClip.
/// This file defines all analytics events tracked in the app with a
/// privacy-first approach - NO clipboard content, text, or PII.
library;

// Event name constants
class AnalyticsEvent {
  const AnalyticsEvent._();

  // Activation events
  static const appFirstLaunch = 'app_first_launch';
  static const permissionAccessibilityRequested =
      'permission_accessibility_requested';
  static const permissionAccessibilityGranted =
      'permission_accessibility_granted';
  static const permissionAccessibilityDenied =
      'permission_accessibility_denied';
  static const clipboardFirstItemCaptured = 'clipboard_first_item_captured';

  // Usage events
  static const clipboardItemCaptured = 'clipboard_item_captured';
  static const clipboardItemUsed = 'clipboard_item_used';
  static const proGateOverlayOpened = 'pro_gate_overlay_opened';
  static const searchUsed = 'search_used';
  static const pasteToAppUsed = 'paste_to_app_used';

  // Monetization events
  static const freeLimitReached = 'free_limit_reached';
  static const itemAutoDeleted = 'item_auto_deleted';
  static const upgradePromptShown = 'upgrade_prompt_shown';
  static const upgradeClicked = 'upgrade_clicked';
  static const proActivated = 'pro_activated';

  // Retention events
  static const appOpened = 'app_opened';
}

// Enums for event properties

/// Enum for the type of limit reached in the free plan
enum LimitType {
  historySize('history_size'),
  retention('retention'),
  excludedApps('excluded_apps');

  const LimitType(this.value);

  final String value;
}

/// Enum for the reason an item was auto-deleted
enum DeletionReason {
  retention('retention'),
  manualCleanup('manual_cleanup');

  const DeletionReason(this.value);

  final String value;
}

/// Enum for the source of an upgrade prompt
enum UpgradeSource {
  limitHit('limit_hit'),
  settings('settings'),
  banner('banner'),
  pinClipboardItem('pin_clipboard_item'),
  ignoredApps('ignored_apps'),
  proGate('pro_gate');

  const UpgradeSource(this.value);

  final String value;
}

/// Enum for day buckets to track retention
enum DayBucket {
  d0('d0'),
  d1('d1'),
  d7('d7'),
  d30('d30');

  const DayBucket(this.value);

  final String value;

  /// Calculate the day bucket based on days since first launch
  static DayBucket fromDaysSinceFirstLaunch(int days) {
    if (days == 0) return DayBucket.d0;
    if (days == 1) return DayBucket.d1;
    if (days >= 2 && days <= 7) return DayBucket.d7;
    return DayBucket.d30;
  }
}

/// Typed helper classes for event parameters

class FreeLimitReachedParams {
  const FreeLimitReachedParams({required this.limitType});

  final LimitType limitType;

  Map<String, Object> toMap() => {'limit_type': limitType.value};
}

class ItemAutoDeletedParams {
  const ItemAutoDeletedParams({required this.reason});

  final DeletionReason reason;

  Map<String, Object> toMap() => {'reason': reason.value};
}

class UpgradePromptShownParams {
  const UpgradePromptShownParams({required this.source});

  final UpgradeSource source;

  Map<String, Object> toMap() => {'source': source.value};
}

class UpgradeClickedParams {
  const UpgradeClickedParams({required this.source});

  final UpgradeSource source;

  Map<String, Object> toMap() => {'source': source.value};
}

class AppOpenedParams {
  const AppOpenedParams({required this.dayBucket});

  final DayBucket dayBucket;

  Map<String, Object> toMap() => {'day_bucket': dayBucket.value};
}

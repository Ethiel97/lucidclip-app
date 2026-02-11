import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/storage/storage.dart';

/// Service to track app launch and retention metrics
@lazySingleton
class RetentionTracker {
  RetentionTracker({required SecureStorageService secureStorageService})
    : _secureStorage = secureStorageService;

  final SecureStorageService _secureStorage;

  static const _firstLaunchKey = 'analytics_first_launch_timestamp';
  static const _lastLaunchKey = 'analytics_last_launch_timestamp';

  /// Track app opened event with day bucket
  Future<void> trackAppOpened() async {
    final now = DateTime.now();
    final firstLaunchStr = await _secureStorage.read(key: _firstLaunchKey);

    // Check if this is the first launch
    if (firstLaunchStr == null) {
      // First launch ever
      await _secureStorage.write(
        key: _firstLaunchKey,
        value: now.toIso8601String(),
      );
      Analytics.track(AnalyticsEvent.appFirstLaunch).unawaited();

      // Track app_opened with d0 bucket
      Analytics.track(
        AnalyticsEvent.appOpened,
        const AppOpenedParams(dayBucket: DayBucket.d0).toMap(),
      ).unawaited();
    } else {
      // Calculate days since first launch
      final firstLaunch = DateTime.parse(firstLaunchStr);
      final daysSinceFirstLaunch = now.difference(firstLaunch).inDays;

      final dayBucket = DayBucket.fromDaysSinceFirstLaunch(
        daysSinceFirstLaunch,
      );

      Analytics.track(
        AnalyticsEvent.appOpened,
        AppOpenedParams(dayBucket: dayBucket).toMap(),
      ).unawaited();
    }

    // Update last launch timestamp
    await _secureStorage.write(
      key: _lastLaunchKey,
      value: now.toIso8601String(),
    );
  }

  /// Check if this is the first time capturing a clipboard item
  Future<bool> isFirstClipboardCapture() async {
    const key = 'analytics_first_clipboard_capture';
    final value = await _secureStorage.read(key: key);
    if (value == null) {
      await _secureStorage.write(key: key, value: 'true');
      return true;
    }
    return false;
  }
}

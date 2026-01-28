import 'package:jiffy/jiffy.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

const warningShowThresholdInHours = 6;

enum RetentionDisplayMode {
  badgeOnly,
  details;

  bool get isBadgeOnly => this == RetentionDisplayMode.badgeOnly;

  bool get isDetails => this == RetentionDisplayMode.details;
}

enum RetentionWarningLevel {
  none,
  warning,
  danger;

  bool get isWarning => this == RetentionWarningLevel.warning;

  bool get isDanger => this == RetentionWarningLevel.danger;

  bool get isNone => this == RetentionWarningLevel.none;
}

class I18nText {
  const I18nText(this.key, [this.args = const {}]);

  final String key;
  final Map<String, Object> args;
}

class RetentionWarning {
  const RetentionWarning({
    required this.level,
    required this.remaining,
    this.text,
  });

  final RetentionWarningLevel level;
  final Duration remaining;
  final I18nText? text;

  static const none = RetentionWarning(
    level: RetentionWarningLevel.none,
    remaining: Duration.zero,
  );
}

class RetentionWarningPolicy {
  const RetentionWarningPolicy({
    required this.now,
    required this.retentionDuration,
    this.showThreshold = const Duration(hours: warningShowThresholdInHours),
  });

  final DateTime Function() now;
  final RetentionDuration retentionDuration;
  final Duration showThreshold;

  RetentionWarning evaluate({
    required ClipboardItem item,
    RetentionDisplayMode mode = RetentionDisplayMode.badgeOnly,
  }) {
    if (retentionDuration.isUnlimited) {
      return RetentionWarning.none;
    }

    final created = item.createdAt.toUtc();
    final expiresAt = created.add(retentionDuration.duration);
    final remaining = expiresAt.difference(now().toUtc());

    if (remaining <= Duration.zero) {
      return const RetentionWarning(
        level: RetentionWarningLevel.danger,
        remaining: Duration.zero,
        text: I18nText('retentionExpired'),
      );
    }

    if (mode.isBadgeOnly && remaining > showThreshold) {
      return RetentionWarning.none;
    }

    final level = remaining <= const Duration(hours: 1)
        ? RetentionWarningLevel.danger
        : RetentionWarningLevel.warning;

    return RetentionWarning(
      level: level,
      remaining: remaining,
      text: I18nText('retentionExpiresIn', {
        'value': _compactValue(remaining),
        'unit': _compactUnit(remaining),
      }),
    );
  }

  int _compactValue(Duration duration) {
    final ref = Jiffy.now().add(minutes: duration.inMinutes);

    if (duration.inDays >= 365) {
      return ref.diff(Jiffy.now(), unit: Unit.year).toInt();
    }
    if (duration.inDays >= 30) {
      return ref.diff(Jiffy.now(), unit: Unit.month).toInt();
    }
    if (duration.inDays >= 1) {
      return ref.diff(Jiffy.now(), unit: Unit.day).toInt();
    }
    if (duration.inHours >= 1) {
      return ref.diff(Jiffy.now(), unit: Unit.hour).toInt();
    }

    return ref.diff(Jiffy.now(), unit: Unit.minute).toInt();
  }

  String _compactUnit(Duration duration) {
    if (duration.inDays >= 365) return 'years';
    if (duration.inDays >= 30) return 'months';
    if (duration.inDays >= 1) return 'days';
    if (duration.inHours >= 1) return 'h';
    return 'min';
  }
}

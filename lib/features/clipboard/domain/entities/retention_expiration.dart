import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:recase/recase.dart';

// 100 years as practical unlimited
const _unlimitedDaysRepresentation = 365 * 100;

/// Defines retention durations for clipboard items.
/// Used to configure how long items are kept before expiration.
enum RetentionDuration {
  /// Retain items for 1 day.
  oneDay,

  /// Retain items for 3 days.
  threeDays,

  /// Retain items for 7 days.
  sevenDays,

  /// Retain items for 30 days.
  thirtyDays,

  /// No expiration; items are kept indefinitely.
  unlimited;

  bool get isUnlimited => this == RetentionDuration.unlimited;

  String resolveLabel(AppLocalizations l10n) => switch (this) {
    RetentionDuration.unlimited => l10n.unlimited,
    RetentionDuration.oneDay => l10n.daysCount(1),
    RetentionDuration.threeDays => l10n.daysCount(3),
    RetentionDuration.sevenDays => l10n.daysCount(7),
    RetentionDuration.thirtyDays => l10n.daysCount(30),
  }.sentenceCase;

  static RetentionDuration fromDays(int days) => switch (days) {
    1 => RetentionDuration.oneDay,
    3 => RetentionDuration.threeDays,
    7 => RetentionDuration.sevenDays,
    30 => RetentionDuration.thirtyDays,
    _unlimitedDaysRepresentation => RetentionDuration.unlimited,
    _ => RetentionDuration.oneDay,
  };

  Duration get duration => switch (this) {
    RetentionDuration.unlimited => const Duration(
      days: _unlimitedDaysRepresentation,
    ),
    RetentionDuration.oneDay => const Duration(days: 1),
    RetentionDuration.threeDays => const Duration(days: 3),
    RetentionDuration.thirtyDays => const Duration(days: 30),
    RetentionDuration.sevenDays => const Duration(days: 7),
  };
}

/// Result of evaluating retention expiration for a clipboard item.
class RetentionExpiration {
  const RetentionExpiration({required this.isExpired, this.expiresAt});

  /// Whether the item has expired and should be deleted.
  final bool isExpired;

  /// The exact DateTime when the item will expire (or did expire).
  final DateTime? expiresAt;
}

/// Policy for evaluating whether clipboard items have expired
/// and should be automatically removed.
///
/// This is a domain-focused policy separate from UI-oriented warning policies.
class RetentionExpirationPolicy {
  const RetentionExpirationPolicy({
    required this.now,
    required this.retentionDuration,
  });

  final DateTime Function() now;
  final RetentionDuration retentionDuration;

  /// Evaluates whether a clipboard item has expired
  /// based on retention policy and returns a [RetentionExpiration]
  /// indicating if the item should be deleted.
  RetentionExpiration evaluate({required ClipboardItem item}) {
    if (retentionDuration.isUnlimited) {
      return const RetentionExpiration(isExpired: false);
    }

    final created = item.createdAt.toUtc();
    final expiresAt = created.add(retentionDuration.duration);
    final currentTime = now().toUtc();
    final isExpired = !currentTime.isBefore(expiresAt);

    return RetentionExpiration(isExpired: isExpired, expiresAt: expiresAt);
  }
}

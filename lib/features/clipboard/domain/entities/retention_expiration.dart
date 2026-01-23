import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

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
    required this.proRetention,
    this.freeRetention = const Duration(days: defaultRetentionDays),
  });

  final DateTime Function() now;
  final Duration freeRetention;
  final Duration proRetention;

  /// Evaluates whether a clipboard item has expired based on retention policy.
  ///
  /// Returns a [RetentionExpiration] indicating if the item should be deleted.
  RetentionExpiration evaluate({
    required ClipboardItem item,
    required bool isPro,
  }) {
    final retention = isPro ? proRetention : freeRetention;

    // Items with zero retention never expire
    if (retention == Duration.zero) {
      return const RetentionExpiration(isExpired: false);
    }

    final created = item.createdAt.toUtc();
    final expiresAt = created.add(retention);
    final currentTime = now().toUtc();
    final isExpired = !currentTime.isBefore(expiresAt);

    return RetentionExpiration(isExpired: isExpired, expiresAt: expiresAt);
  }
}

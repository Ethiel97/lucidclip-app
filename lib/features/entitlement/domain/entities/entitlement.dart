import 'package:equatable/equatable.dart';

class Entitlement extends Equatable {
  const Entitlement({
    required this.id,
    required this.pro,
    required this.source,
    required this.status,
    required this.updatedAt,
    required this.userId,
    required this.validUntil,
  });

  final String id;

  final bool pro;

  final String source;

  final EntitlementStatus status;

  final DateTime updatedAt;

  final String userId;

  final DateTime? validUntil;

  @override
  List<Object?> get props => [
    id,
    pro,
    source,
    status,
    updatedAt,
    userId,
    validUntil,
  ];

  bool get isProActive {
    final now = DateTime.now().toUtc();
    final isStatusActive =
        status == EntitlementStatus.active ||
        status == EntitlementStatus.canceled;
    final isNotExpired =
        validUntil == null || (validUntil?.isAfter(now) ?? false);
    return pro && isStatusActive && isNotExpired;
  }
}

enum EntitlementStatus { inactive, revoked, pastDue, canceled, active }

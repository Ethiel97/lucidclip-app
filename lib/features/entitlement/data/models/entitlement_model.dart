import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/entitlement/domain/domain.dart';

part 'entitlement_model.g.dart';

@JsonSerializable()
class EntitlementModel extends Equatable {
  const EntitlementModel({
    required this.id,
    required this.pro,
    required this.source,
    required this.status,
    required this.updatedAt,
    required this.userId,
    required this.validUntil,
  });

  factory EntitlementModel.fromEntity(Entitlement entitlement) {
    return EntitlementModel(
      id: entitlement.id,
      pro: entitlement.pro,
      source: entitlement.source,
      status: switch (entitlement.status) {
        EntitlementStatus.inactive => EntitlementStatusModel.inactive,
        EntitlementStatus.revoked => EntitlementStatusModel.revoked,
        EntitlementStatus.pastDue => EntitlementStatusModel.pastDue,
        EntitlementStatus.canceled => EntitlementStatusModel.canceled,
        EntitlementStatus.active => EntitlementStatusModel.active,
      },
      updatedAt: entitlement.updatedAt,
      userId: entitlement.userId,
      validUntil: entitlement.validUntil,
    );
  }

  factory EntitlementModel.fromJson(Map<String, dynamic> json) =>
      _$EntitlementModelFromJson(json);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'pro')
  final bool pro;

  @JsonKey(name: 'source')
  final String source;

  @JsonKey(
    name: 'status',
    defaultValue: EntitlementStatusModel.inactive,
    unknownEnumValue: EntitlementStatusModel.inactive,
  )
  final EntitlementStatusModel status;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;

  Map<String, dynamic> toJson() => _$EntitlementModelToJson(this);

  Entitlement toEntity() {
    return Entitlement(
      id: id,
      pro: pro,
      source: source,
      status: switch (status) {
        EntitlementStatusModel.inactive => EntitlementStatus.inactive,
        EntitlementStatusModel.revoked => EntitlementStatus.revoked,
        EntitlementStatusModel.pastDue => EntitlementStatus.pastDue,
        EntitlementStatusModel.canceled => EntitlementStatus.canceled,
        EntitlementStatusModel.active => EntitlementStatus.active,
      },
      updatedAt: updatedAt,
      userId: userId,
      validUntil: validUntil,
    );
  }

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
}

enum EntitlementStatusModel { inactive, revoked, pastDue, canceled, active }

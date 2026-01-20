// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntitlementModel _$EntitlementModelFromJson(Map<String, dynamic> json) =>
    EntitlementModel(
      id: json['id'] as String,
      pro: json['pro'] as bool,
      source: json['source'] as String,
      status:
          $enumDecodeNullable(
            _$EntitlementStatusModelEnumMap,
            json['status'],
            unknownValue: EntitlementStatusModel.inactive,
          ) ??
          EntitlementStatusModel.inactive,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
      validUntil: json['valid_until'] == null
          ? null
          : DateTime.parse(json['valid_until'] as String),
    );

Map<String, dynamic> _$EntitlementModelToJson(EntitlementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pro': instance.pro,
      'source': instance.source,
      'status': _$EntitlementStatusModelEnumMap[instance.status]!,
      'updated_at': instance.updatedAt.toIso8601String(),
      'user_id': instance.userId,
      'valid_until': instance.validUntil?.toIso8601String(),
    };

const _$EntitlementStatusModelEnumMap = {
  EntitlementStatusModel.inactive: 'inactive',
  EntitlementStatusModel.revoked: 'revoked',
  EntitlementStatusModel.pastDue: 'pastDue',
  EntitlementStatusModel.canceled: 'canceled',
  EntitlementStatusModel.active: 'active',
};

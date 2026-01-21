// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_portal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerPortalModel _$CustomerPortalModelFromJson(Map<String, dynamic> json) =>
    CustomerPortalModel(
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      url: json['url'] as String,
    );

Map<String, dynamic> _$CustomerPortalModelToJson(
  CustomerPortalModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

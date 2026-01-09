// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceAppModel _$SourceAppModelFromJson(Map<String, dynamic> json) =>
    SourceAppModel(
      bundleId: json['bundle_id'] as String,
      name: json['name'] as String,
      icon: const Uint8ListConverter().fromJson(json['icon'] as String?),
    );

Map<String, dynamic> _$SourceAppModelToJson(SourceAppModel instance) =>
    <String, dynamic>{
      'bundle_id': instance.bundleId,
      'name': instance.name,
      'icon': const Uint8ListConverter().toJson(instance.icon),
    };

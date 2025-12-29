// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) => TagModel(
  color: json['color'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  id: json['id'] as String,
  name: json['name'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
  'color': instance.color,
  'created_at': instance.createdAt.toIso8601String(),
  'id': instance.id,
  'updated_at': instance.updatedAt.toIso8601String(),
  'user_id': instance.userId,
  'name': instance.name,
};

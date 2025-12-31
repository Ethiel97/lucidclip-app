// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_item_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipboardItemTagModel _$ClipboardItemTagModelFromJson(
  Map<String, dynamic> json,
) => ClipboardItemTagModel(
  clipboardItemId: json['clipboard_item_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  tagId: json['tag_id'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ClipboardItemTagModelToJson(
  ClipboardItemTagModel instance,
) => <String, dynamic>{
  'clipboard_item_id': instance.clipboardItemId,
  'created_at': instance.createdAt.toIso8601String(),
  'tag_id': instance.tagId,
  'updated_at': instance.updatedAt.toIso8601String(),
};

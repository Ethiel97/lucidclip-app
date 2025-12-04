// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipboardHistoryModel _$ClipboardHistoryModelFromJson(
        Map<String, dynamic> json) =>
    ClipboardHistoryModel(
      action: $enumDecodeNullable(_$ClipboardActionModelEnumMap, json['action'],
              unknownValue: ClipboardActionModel.copy) ??
          ClipboardActionModel.copy,
      clipboardItemId: json['clipboard_item_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ClipboardHistoryModelToJson(
        ClipboardHistoryModel instance) =>
    <String, dynamic>{
      'action': _$ClipboardActionModelEnumMap[instance.action]!,
      'clipboard_item_id': instance.clipboardItemId,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'updated_at': instance.updatedAt.toIso8601String(),
      'user_id': instance.userId,
    };

const _$ClipboardActionModelEnumMap = {
  ClipboardActionModel.copy: 'copy',
  ClipboardActionModel.paste: 'paste',
  ClipboardActionModel.delete: 'delete',
  ClipboardActionModel.edit: 'edit',
};

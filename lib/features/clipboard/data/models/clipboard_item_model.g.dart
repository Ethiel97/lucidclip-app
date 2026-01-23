// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipboardItemModel _$ClipboardItemModelFromJson(Map<String, dynamic> json) =>
    ClipboardItemModel(
      content: json['content'] as String,
      contentHash: json['content_hash'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as String,
      type:
          $enumDecodeNullable(
            _$ClipboardItemTypeModelEnumMap,
            json['type'],
            unknownValue: ClipboardItemTypeModel.unknown,
          ) ??
          ClipboardItemTypeModel.unknown,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
      isPinned: json['is_pinned'] as bool? ?? false,
      isSnippet: json['is_snippet'] as bool? ?? false,
      isSynced: json['is_synced'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      usageCount: (json['usage_count'] as num?)?.toInt() ?? 0,
      filePath: json['file_path'] as String?,
      htmlContent: json['html_content'] as String?,
      imageBytes: (json['image_bytes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      lastUsedAt: json['last_used_at'] == null
          ? null
          : DateTime.parse(json['last_used_at'] as String),
    );

Map<String, dynamic> _$ClipboardItemModelToJson(ClipboardItemModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'content_hash': instance.contentHash,
      'created_at': instance.createdAt.toIso8601String(),
      'file_path': instance.filePath,
      'html_content': instance.htmlContent,
      'id': instance.id,
      'image_bytes': instance.imageBytes,
      'is_pinned': instance.isPinned,
      'is_snippet': instance.isSnippet,
      'is_synced': instance.isSynced,
      'last_used_at': instance.lastUsedAt?.toIso8601String(),
      'metadata': instance.metadata,
      'type': _$ClipboardItemTypeModelEnumMap[instance.type]!,
      'updated_at': instance.updatedAt.toIso8601String(),
      'usage_count': instance.usageCount,
      'user_id': instance.userId,
    };

const _$ClipboardItemTypeModelEnumMap = {
  ClipboardItemTypeModel.text: 'text',
  ClipboardItemTypeModel.image: 'image',
  ClipboardItemTypeModel.file: 'file',
  ClipboardItemTypeModel.url: 'url',
  ClipboardItemTypeModel.html: 'html',
  ClipboardItemTypeModel.unknown: 'unknown',
};

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_item_model.g.dart';

typedef ClipboardItemModels = List<ClipboardItemModel>;

@JsonSerializable(explicitToJson: true)
class ClipboardItemModel extends Equatable {
  const ClipboardItemModel({
    required this.content,
    required this.contentHash,
    required this.createdAt,
    required this.id,
    required this.type,
    required this.updatedAt,
    required this.userId,
    this.isPinned = false,
    this.isSnippet = false,
    this.isSynced = false,
    this.metadata = const {},
    this.usageCount = 0,
    this.filePath,
    this.htmlContent,
    this.imageBytes,
    this.lastUsedAt,
  });

  factory ClipboardItemModel.fromEntity(ClipboardItem item) {
    return ClipboardItemModel(
      content: item.content,
      contentHash: item.contentHash,
      createdAt: item.createdAt,
      filePath: item.filePath,
      htmlContent: item.htmlContent,
      id: item.id,
      imageBytes: item.imageBytes,
      isPinned: item.isPinned,
      isSnippet: item.isSnippet,
      lastUsedAt: item.lastUsedAt,
      metadata: item.metadata,
      type: ClipboardItemTypeModel.values[item.type.index],
      updatedAt: item.updatedAt,
      usageCount: item.usageCount,
      userId: item.userId,
    );
  }

  factory ClipboardItemModel.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemModelFromJson(json);

  final String content;

  @JsonKey(name: 'content_hash')
  final String contentHash;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'file_path')
  final String? filePath;

  @JsonKey(name: 'html_content')
  final String? htmlContent;
  final String id;

  @JsonKey(name: 'image_bytes')
  final List<int>? imageBytes;

  @JsonKey(name: 'is_pinned')
  final bool isPinned;

  @JsonKey(name: 'is_snippet')
  final bool isSnippet;

  @JsonKey(name: 'is_synced')
  final bool isSynced;

  @JsonKey(name: 'last_used_at')
  final DateTime? lastUsedAt;

  final Map<String, dynamic> metadata;

  @JsonKey(
    defaultValue: ClipboardItemTypeModel.unknown,
    unknownEnumValue: ClipboardItemTypeModel.unknown,
  )
  final ClipboardItemTypeModel type;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'usage_count')
  final int usageCount;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$ClipboardItemModelToJson(this);

  //copyWith method
  ClipboardItemModel copyWith({
    String? content,
    String? contentHash,
    DateTime? createdAt,
    String? filePath,
    String? htmlContent,
    String? id,
    List<int>? imageBytes,
    bool? isPinned,
    bool? isSnippet,
    bool? isSynced,
    DateTime? lastUsedAt,
    Map<String, dynamic>? metadata,
    ClipboardItemTypeModel? type,
    DateTime? updatedAt,
    int? usageCount,
    String? userId,
  }) {
    return ClipboardItemModel(
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      createdAt: createdAt ?? this.createdAt,
      filePath: filePath ?? this.filePath,
      htmlContent: htmlContent ?? this.htmlContent,
      id: id ?? this.id,
      imageBytes: imageBytes ?? this.imageBytes,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      isSynced: isSynced ?? this.isSynced,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
      userId: userId ?? this.userId,
    );
  }

  ClipboardItem toEntity() {
    return ClipboardItem(
      content: content,
      contentHash: contentHash,
      createdAt: createdAt,
      filePath: filePath,
      htmlContent: htmlContent,
      id: id,
      imageBytes: imageBytes,
      isPinned: isPinned,
      isSnippet: isSnippet,
      lastUsedAt: lastUsedAt,
      metadata: metadata,
      type: ClipboardItemType.values[type.index],
      updatedAt: updatedAt,
      usageCount: usageCount,
      userId: userId,
    );
  }

  @override
  List<Object?> get props => [
    content,
    contentHash,
    createdAt,
    filePath,
    htmlContent,
    id,
    imageBytes,
    isPinned,
    isSnippet,
    isSynced,
    lastUsedAt,
    metadata,
    type,
    updatedAt,
    usageCount,
    userId,
  ];
}

enum ClipboardItemTypeModel { text, image, file, url, html, unknown }

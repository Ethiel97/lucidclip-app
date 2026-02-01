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
    required this.syncStatus,
    required this.type,
    required this.updatedAt,
    required this.userId,
    this.isPinned = false,
    this.isSnippet = false,
    this.metadata = const {},
    this.usageCount = 0,
    this.version = 0,
    this.deletedAt,
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
      deletedAt: item.deletedAt,
      filePath: item.filePath,
      htmlContent: item.htmlContent,
      id: item.id,
      imageBytes: item.imageBytes,
      isPinned: item.isPinned,
      isSnippet: item.isSnippet,
      lastUsedAt: item.lastUsedAt,
      metadata: item.metadata,
      syncStatus: SyncStatusModel.values[item.syncStatus.index],
      type: ClipboardItemTypeModel.values[item.type.index],
      updatedAt: item.updatedAt,
      usageCount: item.usageCount,
      userId: item.userId,
      version: item.version,
    );
  }

  factory ClipboardItemModel.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemModelFromJson(json);

  final String content;

  @JsonKey(name: 'content_hash')
  final String contentHash;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

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

  @JsonKey(name: 'last_used_at')
  final DateTime? lastUsedAt;

  final Map<String, dynamic> metadata;

  @JsonKey(
    name: 'sync_status',
    defaultValue: SyncStatusModel.clean,
    unknownEnumValue: SyncStatusModel.clean,
  )
  final SyncStatusModel syncStatus;

  final int version;

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
    DateTime? deletedAt,
    String? filePath,
    String? htmlContent,
    String? id,
    List<int>? imageBytes,
    bool? isPinned,
    bool? isSnippet,
    DateTime? lastUsedAt,
    Map<String, dynamic>? metadata,
    SyncStatusModel? syncStatus,
    ClipboardItemTypeModel? type,
    DateTime? updatedAt,
    int? usageCount,
    String? userId,
    int? version,
  }) {
    return ClipboardItemModel(
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      filePath: filePath ?? this.filePath,
      htmlContent: htmlContent ?? this.htmlContent,
      id: id ?? this.id,
      imageBytes: imageBytes ?? this.imageBytes,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      metadata: metadata ?? this.metadata,
      syncStatus: syncStatus ?? this.syncStatus,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      usageCount: usageCount ?? this.usageCount,
      userId: userId ?? this.userId,
      version: version ?? this.version,
    );
  }

  ClipboardItem toEntity() {
    return ClipboardItem(
      content: content,
      contentHash: contentHash,
      createdAt: createdAt,
      deletedAt: deletedAt,
      filePath: filePath,
      htmlContent: htmlContent,
      id: id,
      imageBytes: imageBytes,
      isPinned: isPinned,
      isSnippet: isSnippet,
      lastUsedAt: lastUsedAt,
      metadata: metadata,
      syncStatus: SyncStatus.values[syncStatus.index],
      type: ClipboardItemType.values[type.index],
      updatedAt: updatedAt,
      usageCount: usageCount,
      userId: userId,
      version: version,
    );
  }

  @override
  List<Object?> get props => [
    content,
    contentHash,
    createdAt,
    deletedAt,
    filePath,
    htmlContent,
    id,
    imageBytes,
    isPinned,
    isSnippet,
    lastUsedAt,
    metadata,
    syncStatus,
    type,
    updatedAt,
    usageCount,
    userId,
    version,
  ];
}

enum ClipboardItemTypeModel { text, image, file, url, html, unknown }

enum SyncStatusModel { clean, dirty, pending, conflict, error, unknown }

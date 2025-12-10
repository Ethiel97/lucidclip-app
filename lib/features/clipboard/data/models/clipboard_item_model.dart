import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_item_model.g.dart';

typedef ClipboardItemModels = List<ClipboardItemModel>;

@JsonSerializable(
  explicitToJson: true,
)
class ClipboardItemModel {
  ClipboardItemModel({
    required this.content,
    required this.contentHash,
    required this.createdAt,
    required this.id,
    required this.type,
    required this.updatedAt,
    required this.userId,
    this.imageUrl,
    this.filePaths = const [],
    this.isPinned = false,
    this.isSnippet = false,
    this.isSynced = false,
    this.metadata = const {},
    this.htmlContent,
  });

  factory ClipboardItemModel.fromEntity(ClipboardItem item) {
    return ClipboardItemModel(
      content: item.content,
      contentHash: item.contentHash,
      createdAt: item.createdAt,
      filePaths: item.filePaths,
      htmlContent: item.htmlContent,
      id: item.id,
      imageUrl: item.imageUrl,
      isPinned: item.isPinned,
      isSnippet: item.isSnippet,
      metadata: item.metadata,
      type: ClipboardItemTypeModel.values[item.type.index],
      updatedAt: item.updatedAt,
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

  @JsonKey(name: 'file_paths')
  final List<String> filePaths;

  @JsonKey(name: 'html_content')
  final String? htmlContent;
  final String id;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'is_pinned')
  final bool isPinned;

  @JsonKey(name: 'is_snippet')
  final bool isSnippet;

  @JsonKey(name: 'is_synced', defaultValue: false)
  final bool isSynced;

  final Map<String, dynamic> metadata;

  @JsonKey(
    defaultValue: ClipboardItemTypeModel.unknown,
    unknownEnumValue: ClipboardItemTypeModel.unknown,
  )
  final ClipboardItemTypeModel type;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$ClipboardItemModelToJson(this);

  //copyWith method
  ClipboardItemModel copyWith({
    String? content,
    String? contentHash,
    DateTime? createdAt,
    List<String>? filePaths,
    String? htmlContent,
    String? id,
    String? imageUrl,
    bool? isPinned,
    bool? isSnippet,
    bool? isSynced,
    Map<String, dynamic>? metadata,
    ClipboardItemTypeModel? type,
    DateTime? updatedAt,
    String? userId,
  }) {
    return ClipboardItemModel(
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      createdAt: createdAt ?? this.createdAt,
      filePaths: filePaths ?? this.filePaths,
      htmlContent: htmlContent ?? this.htmlContent,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      isSynced: isSynced ?? this.isSynced,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  ClipboardItem toEntity() {
    return ClipboardItem(
      content: content,
      contentHash: contentHash,
      createdAt: createdAt,
      filePaths: filePaths,
      htmlContent: htmlContent,
      id: id,
      imageUrl: imageUrl,
      isPinned: isPinned,
      isSnippet: isSnippet,
      metadata: metadata,
      type: ClipboardItemType.values[type.index],
      updatedAt: updatedAt,
      userId: userId,
    );
  }
}

enum ClipboardItemTypeModel {
  text,
  image,
  file,
  url,
  html,
  unknown;
}

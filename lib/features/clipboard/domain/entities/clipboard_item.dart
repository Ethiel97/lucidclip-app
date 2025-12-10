import 'package:json_annotation/json_annotation.dart';

typedef ClipboardItems = List<ClipboardItem>;
class ClipboardItem {
  ClipboardItem({
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
    this.metadata = const {},
    this.htmlContent,
  });

  final String content;

  final String contentHash;
  final DateTime createdAt;

  final List<String> filePaths;

  final String? htmlContent;
  final String id;
  final String? imageUrl;
  final bool isPinned;

  final bool isSnippet;
  final Map<String, dynamic> metadata;

  @JsonKey(
    defaultValue: ClipboardItemType.unknown,
    unknownEnumValue: ClipboardItemType.unknown,
  )
  final ClipboardItemType type;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;


  //copyWith method
  ClipboardItem copyWith({
    String? content,
    String? contentHash,
    DateTime? createdAt,
    List<String>? filePaths,
    String? htmlContent,
    String? id,
    String? imageUrl,
    bool? isPinned,
    bool? isSnippet,
    Map<String, dynamic>? metadata,
    ClipboardItemType? type,
    DateTime? updatedAt,
    String? userId,
  }) {
    return ClipboardItem(
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      createdAt: createdAt ?? this.createdAt,
      filePaths: filePaths ?? this.filePaths,
      htmlContent: htmlContent ?? this.htmlContent,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}

enum ClipboardItemType {
  text,
  image,
  file,
  url,
  html,
  unknown;

  bool get isText => this == ClipboardItemType.text;

  bool get isImage => this == ClipboardItemType.image;

  bool get isFile => this == ClipboardItemType.file;

  bool get isUrl => this == ClipboardItemType.url;

  bool get isHtml => this == ClipboardItemType.html;

  bool get isUnknown => this == ClipboardItemType.unknown;
}

import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:recase/recase.dart';

typedef ClipboardItems = List<ClipboardItem>;

class ClipboardItem extends Equatable {
  const ClipboardItem({
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

  factory ClipboardItem.empty() {
    return ClipboardItem(
      content: '',
      contentHash: '',
      createdAt: DateTime.now(),
      id: '',
      type: ClipboardItemType.unknown,
      updatedAt: DateTime.now(),
      userId: '',
    );
  }

  static ClipboardItem emptyValue = ClipboardItem.empty();

  bool get isEmpty => this == ClipboardItem.emptyValue;

  final String content;

  final String contentHash;
  final DateTime createdAt;

  final List<String> filePaths;

  final String? htmlContent;
  final String id;
  final String? imageUrl;
  final bool isPinned;

  final bool isSnippet;
  final bool isSynced;
  final Map<String, dynamic> metadata;

  final ClipboardItemType type;

  final DateTime updatedAt;

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
    bool? isSynced,
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
      isSynced: isSynced ?? this.isSynced,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
    content,
    contentHash,
    createdAt,
    filePaths,
    htmlContent,
    id,
    imageUrl,
    isPinned,
    isSnippet,
    isSynced,
    metadata,
    type,
    updatedAt,
    userId,
  ];
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

  String get label {
    return switch (this) {
      ClipboardItemType.url => 'Link',
      _ => name,
    };
  }
}

/// Extension to map ClipboardItem to ClipboardContentType for reusability
extension ClipboardItemHelper on ClipboardItem {
  /// Maps the ClipboardItem type to ClipboardContentType
  ClipboardContentType get contentType => switch (type) {
    ClipboardItemType.text => ClipboardContentType.text,
    ClipboardItemType.image => ClipboardContentType.image,
    ClipboardItemType.file => ClipboardContentType.file,
    ClipboardItemType.url => ClipboardContentType.url,
    ClipboardItemType.html => ClipboardContentType.html,
    ClipboardItemType.unknown => ClipboardContentType.unknown,
  };

  String get timeAgo =>
      Jiffy.parseFromDateTime(createdAt).fromNow().sentenceCase;
}

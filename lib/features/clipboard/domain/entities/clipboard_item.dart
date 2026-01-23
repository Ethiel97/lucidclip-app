import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart' hide Unit;
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:proper_filesize/proper_filesize.dart';
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

  factory ClipboardItem.empty() {
    return ClipboardItem(
      content: '',
      contentHash: '',
      createdAt: DateTime.now().toUtc(),
      id: '',
      type: ClipboardItemType.unknown,
      updatedAt: DateTime.now().toUtc(),
      userId: '',
    );
  }

  static ClipboardItem emptyValue = ClipboardItem.empty();

  bool get isEmpty => this == ClipboardItem.emptyValue;

  final String content;

  final String contentHash;
  final DateTime createdAt;

  final String? filePath;

  final String? htmlContent;
  final String id;
  final List<int>? imageBytes;
  final bool isPinned;

  final bool isSnippet;
  final bool isSynced;

  final DateTime? lastUsedAt;
  final Map<String, dynamic> metadata;

  final ClipboardItemType type;

  final DateTime updatedAt;
  final int usageCount;

  final String userId;

  //copyWith method
  ClipboardItem copyWith({
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
    ClipboardItemType? type,
    DateTime? updatedAt,
    int? usageCount,
    String? userId,
  }) {
    return ClipboardItem(
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

  String get userFacingSize {
    var sizeInBytes = 0;
    if (type.isImage && imageBytes != null) {
      sizeInBytes = imageBytes!.length;
    } else {
      sizeInBytes = utf8.encode(content).length;
    }

    return FileSize.fromBytes(
      sizeInBytes,
    ).toString(unit: Unit.kilobyte, decimals: 0);
  }

  SourceApp? get sourceApp {
    if (metadata.containsKey('source_app')) {
      final sourceAppData = metadata['source_app'];

      if (sourceAppData is Map<String, dynamic>) {
        return SourceAppModel.fromJsonWithIcon(sourceAppData).toEntity();
      }
    }
    return null;
  }

  bool getIsSourceAppExcluded(List<SourceApp> excludedApps) {
    final app = sourceApp;
    if (app != null) {
      return excludedApps.any(
        (excludedApp) => excludedApp.bundleId == app.bundleId,
      );
    }
    return false;
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

enum ClipboardItemType {
  text,
  image,
  file,
  url,
  html,
  unknown;

  List<ClipboardItemType> get filterableTypes => [
    ClipboardItemType.text,
    ClipboardItemType.image,
    ClipboardItemType.file,
    ClipboardItemType.url,
  ];

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
      Jiffy.parseFromDateTime(createdAt).toUtc().fromNow().sentenceCase;

  Duration get durationUntilExpiration {
    final expirationTime = createdAt.add(const Duration(days: 1));
    final remaining = expirationTime.difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// return expiration (remove after 24 hours) in hours as string
  String get hoursUntilExpiration {
    final remaining = durationUntilExpiration.inHours;
    return remaining.clamp(0, 24).toString();
  }

  bool get shouldShowExpirationBadge {
    return durationUntilExpiration.inHours <= 6;
  }
}

// lib/core/clipboard_manager/clipboard_manager.dart

import 'package:equatable/equatable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

abstract class BaseClipboardManager {
  static const clipboardPollingInterval = Duration(milliseconds: 1200);

  void initialize();

  Future<ClipboardData?> getClipboardContent();

  Future<void> setClipboardContent(ClipboardData data);

  Stream<ClipboardData> watchClipboard();

  Future<bool> hasContent();

  Future<void> clear();

  Future<void> dispose();

  Future<int> getSize();
}

class ClipboardData extends Equatable {
  const ClipboardData({
    required this.type,
    this.contentHash,
    this.filePath,
    this.html,
    this.imageBytes,
    this.metadata,
    this.text,
    this.timestamp,
  });

  final String? contentHash;
  final String? filePath;
  final String? html;
  final List<int>? imageBytes;
  final Map<String, dynamic>? metadata;
  final String? text;
  final DateTime? timestamp;
  final ClipboardContentType type;

  ClipboardData copyWith({
    String? contentHash,
    String? filePath,
    String? html,
    List<int>? imageBytes,
    Map<String, dynamic>? metadata,
    String? text,
    DateTime? timestamp,
    ClipboardContentType? type,
  }) {
    return ClipboardData(
      contentHash: contentHash ?? this.contentHash,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      html: html ?? this.html,
      imageBytes: imageBytes ?? this.imageBytes,
      metadata: metadata ?? this.metadata,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    contentHash,
    filePath,
    html,
    imageBytes,
    metadata,
    text,
    timestamp,
    type,
  ];

  SourceApp? get sourceApp {
    if (metadata?.containsKey('source_app') ?? false) {
      final appData = metadata!['source_app'] as Map<String, dynamic>;
      return SourceAppModel.fromJson(appData).toEntity();
    }
    return null;
  }
}

enum ClipboardContentType { file, html, image, text, unknown, url }

extension ClipboardDataHelpers on ClipboardData {
  ClipboardItemType get clipboardItemType {
    switch (type) {
      case ClipboardContentType.text:
        return ClipboardItemType.text;
      case ClipboardContentType.image:
        return ClipboardItemType.image;
      case ClipboardContentType.file:
        return ClipboardItemType.file;
      case ClipboardContentType.url:
        return ClipboardItemType.url;
      case ClipboardContentType.html:
        return ClipboardItemType.html;
      case ClipboardContentType.unknown:
        return ClipboardItemType.unknown;
    }
  }
}

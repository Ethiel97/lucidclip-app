// lib/core/clipboard_manager/clipboard_manager.dart
abstract class BaseClipboardManager {

  static const clipboardPollingInterval = Duration(milliseconds: 500);
  Future<void> initialize();

  Future<ClipboardData?> getClipboardContent();

  Future<void> setClipboardContent(ClipboardData data);

  Stream<ClipboardData> watchClipboard();

  Future<bool> hasContent();

  Future<void> clear();

  Future<void> dispose();

  Future<int> getSize();
}

class ClipboardData {
  const ClipboardData({
    required this.type,
    this.filePaths,
    this.html,
    this.imageBytes,
    this.metadata,
    this.text,
    this.timestamp,
  });

  final List<String>? filePaths;
  final String? html;
  final List<int>? imageBytes;
  final Map<String, dynamic>? metadata;
  final String? text;
  final DateTime? timestamp;
  final ClipboardContentType type;

  ClipboardData copyWith({
    ClipboardContentType? type,
    List<String>? filePaths,
    String? html,
    List<int>? imageBytes,
    Map<String, dynamic>? metadata,
    String? text,
    DateTime? timestamp,
  }) {
    return ClipboardData(
      type: type ?? this.type,
      filePaths: filePaths ?? this.filePaths,
      html: html ?? this.html,
      imageBytes: imageBytes ?? this.imageBytes,
      metadata: metadata ?? this.metadata,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum ClipboardContentType {
  text,
  image,
  file,
  url,
  html,
  unknown,
}

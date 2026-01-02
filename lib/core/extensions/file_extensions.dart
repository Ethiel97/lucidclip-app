import 'dart:io';

extension FileHelper on File {
  /// Returns the file size in a human-readable format (e.g., KB, MB, GB).
  String get extension {
    final parts = path.split('.');
    if (parts.length > 1) {
      return parts.last.toLowerCase();
    }
    return '';
  }

  bool get isImage {
    final imageExtensions = [
      'png',
      'jpg',
      'jpeg',
      'gif',
      'webp',
      'bmp',
      'tiff',
      'heic',
      'svg',
      'avif',
    ];
    return imageExtensions.contains(extension);
  }

  bool get isVideo {
    final videoExtensions = [
      'mp4',
      'mov',
      'wmv',
      'flv',
      'avi',
      'mkv',
      'webm',
      'avchd',
      'm4v',
    ];
    return videoExtensions.contains(extension);
  }

  bool get isDocument {
    final documentExtensions = [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'rtf',
      'odt',
    ];
    return documentExtensions.contains(extension);
  }
}

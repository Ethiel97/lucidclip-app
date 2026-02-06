/// Abstract share service interface for LucidClip.
/// This interface defines the contract for all share implementations.
library;

/// Abstract share service for sharing content.
///
/// Implementations should:
/// - Share text, URLs, files, and images
/// - Respect platform capabilities
/// - Handle errors gracefully
abstract class ShareService {
  /// Share text content
  ///
  /// [text] - The text to share
  /// [subject] - Optional subject/title for the share
  Future<void> shareText(String text, {String? subject});

  /// Share a URL
  ///
  /// [url] - The URL to share
  /// [subject] - Optional subject/title for the share
  Future<void> shareUrl(String url, {String? subject});

  /// Share a file
  ///
  /// [filePath] - The path to the file to share
  /// [subject] - Optional subject/title for the share
  Future<void> shareFile(String filePath, {String? subject});

  /// Share an image
  ///
  /// [imagePath] - The path to the image to share
  /// [subject] - Optional subject/title for the share
  Future<void> shareImage(String imagePath, {String? subject});

  /// Share image bytes as a temporary file
  ///
  /// [imageBytes] - The image data as bytes
  /// [subject] - Optional subject/title for the share
  Future<void> shareImageBytes(List<int> imageBytes, {String? subject});

  /// Whether share is supported on the current platform
  bool get isSupported;
}

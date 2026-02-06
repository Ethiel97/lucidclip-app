import 'dart:developer' as developer;

import 'package:lucid_clip/core/services/share_service/share_service.dart';

/// Global share singleton entry point.
///
/// This provides a single, convenient access point for sharing content
/// throughout the app, following the same pattern as Analytics.
///
/// Usage:
/// ```dart
/// Share.shareText('Hello world!');
/// Share.shareUrl('https://example.com');
/// Share.shareFile('/path/to/file.pdf');
/// ```
class Share {
  Share._();

  static ShareService? _instance;

  /// Initialize the share service
  // ignore: use_setters_to_change_properties
  static void initialize(ShareService service) => _instance = service;

  /// Share text content
  static Future<void> shareText(String text, {String? subject}) async {
    if (_instance == null) {
      developer.log(
        'Share service not initialized',
        name: 'Share.shareText',
      );
      return;
    }
    await _instance!.shareText(text, subject: subject);
  }

  /// Share a URL
  static Future<void> shareUrl(String url, {String? subject}) async {
    if (_instance == null) {
      developer.log(
        'Share service not initialized',
        name: 'Share.shareUrl',
      );
      return;
    }
    await _instance!.shareUrl(url, subject: subject);
  }

  /// Share a file
  static Future<void> shareFile(String filePath, {String? subject}) async {
    if (_instance == null) {
      developer.log(
        'Share service not initialized',
        name: 'Share.shareFile',
      );
      return;
    }
    await _instance!.shareFile(filePath, subject: subject);
  }

  /// Share an image
  static Future<void> shareImage(String imagePath, {String? subject}) async {
    if (_instance == null) {
      developer.log(
        'Share service not initialized',
        name: 'Share.shareImage',
      );
      return;
    }
    await _instance!.shareImage(imagePath, subject: subject);
  }

  /// Share image bytes
  static Future<void> shareImageBytes(
    List<int> imageBytes, {
    String? subject,
  }) async {
    if (_instance == null) {
      developer.log(
        'Share service not initialized',
        name: 'Share.shareImageBytes',
      );
      return;
    }
    await _instance!.shareImageBytes(imageBytes, subject: subject);
  }

  /// Whether share is supported
  static bool get isSupported => _instance?.isSupported ?? false;
}

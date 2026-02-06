import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/services/share_service/share_service.dart';
import 'package:share_plus/share_plus.dart';

/// Share service implementation using share_plus package
@LazySingleton(as: ShareService)
class SharePlusService implements ShareService {
  final sharePlus = SharePlus.instance;

  @override
  bool get isSupported =>
      Platform.isMacOS ||
      Platform.isIOS ||
      Platform.isAndroid ||
      Platform.isWindows ||
      Platform.isLinux;

  @override
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await sharePlus.share(ShareParams(text: text, subject: subject));

      // Track share usage
      await Analytics.track(
        AnalyticsEvent.shareUsed,
        const ClipboardItemSharedParams(contentType: 'text').toMap(),
      );
    } catch (e, stack) {
      developer.log(
        'Error sharing text: $e',
        name: 'SharePlusService.shareText',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> shareUrl(String url, {String? subject}) async {
    try {
      await sharePlus.share(ShareParams(text: url, subject: subject));

      // Track share usage
      await Analytics.track(
        AnalyticsEvent.shareUsed,
        const ClipboardItemSharedParams(contentType: 'url').toMap(),
      );
    } catch (e, stack) {
      developer.log(
        'Error sharing URL: $e',
        name: 'SharePlusService.shareUrl',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> shareFile(String filePath, {String? subject}) async {
    try {
      final file = XFile(filePath);

      await sharePlus.share(
        ShareParams(text: filePath, subject: subject, files: [file]),
      );

      // Track share usage
      await Analytics.track(
        AnalyticsEvent.shareUsed,
        const ClipboardItemSharedParams(contentType: 'file').toMap(),
      );
    } catch (e, stack) {
      developer.log(
        'Error sharing file: $e',
        name: 'SharePlusService.shareFile',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> shareImage(String imagePath, {String? subject}) async {
    try {
      final image = XFile(imagePath);

      await sharePlus.share(
        ShareParams(text: imagePath, subject: subject, files: [image]),
      );

      await Analytics.track(
        AnalyticsEvent.shareUsed,
        const ClipboardItemSharedParams(contentType: 'image').toMap(),
      );
    } catch (e, stack) {
      developer.log(
        'Error sharing image: $e',
        name: 'SharePlusService.shareImage',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> shareImageBytes(List<int> imageBytes, {String? subject}) async {
    try {
      // Detect image format from bytes
      var extension = 'png'; // default
      if (imageBytes.length >= 2) {
        // Check for common image formats by magic bytes
        if (imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
          extension = 'jpg'; // JPEG
        } else if (imageBytes.length >= 4 &&
            imageBytes[0] == 0x89 &&
            imageBytes[1] == 0x50 &&
            imageBytes[2] == 0x4E &&
            imageBytes[3] == 0x47) {
          extension = 'png'; // PNG
        } else if (imageBytes.length >= 6 &&
            imageBytes[0] == 0x47 &&
            imageBytes[1] == 0x49 &&
            imageBytes[2] == 0x46 &&
            imageBytes[3] == 0x38 &&
            (imageBytes[4] == 0x37 || imageBytes[4] == 0x39) &&
            imageBytes[5] == 0x61) {
          extension = 'gif'; // GIF87a or GIF89a
        }
      }

      // Create a temporary file for the image
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/shared_image_${DateTime.now().millisecondsSinceEpoch}.$extension',
      );
      await tempFile.writeAsBytes(imageBytes);

      final image = XFile(tempFile.path);
      await sharePlus.share(
        ShareParams(text: tempFile.path, subject: subject, files: [image]),
      );

      // Clean up the temporary file after a reasonable delay
      // Give more time for the share operation to complete across platforms
      // Using unawaited to explicitly mark this as fire-and-forget
      unawaited(
        Future.delayed(const Duration(seconds: 10), () async {
          try {
            if (tempFile.existsSync()) {
              await tempFile.delete();
            }
          } catch (e) {
            developer.log(
              'Error deleting temporary image file: $e',
              name: 'SharePlusService.shareImageBytes',
            );
          }
        }),
      );

      // Track share usage
      await Analytics.track(
        AnalyticsEvent.shareUsed,
        const ClipboardItemSharedParams(contentType: 'image').toMap(),
      );
    } catch (e, stack) {
      developer.log(
        'Error sharing image bytes: $e',
        name: 'SharePlusService.shareImageBytes',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

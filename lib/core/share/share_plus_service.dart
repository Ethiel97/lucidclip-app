import 'dart:developer' as developer;
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/share/share_service.dart';
import 'package:share_plus/share_plus.dart';

/// Share service implementation using share_plus package
@LazySingleton(as: ShareService)
class SharePlusService implements ShareService {
  @override
  bool get isSupported {
    // share_plus supports macOS, iOS, Android, Windows, and Linux
    return Platform.isMacOS ||
        Platform.isIOS ||
        Platform.isAndroid ||
        Platform.isWindows ||
        Platform.isLinux;
  }

  @override
  Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
      
      // Track share usage
      await Analytics.track(AnalyticsEvent.shareUsed, {
        'content_type': 'text',
      });
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
      await Share.share(
        url,
        subject: subject,
      );
      
      // Track share usage
      await Analytics.track(AnalyticsEvent.shareUsed, {
        'content_type': 'url',
      });
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
      await Share.shareXFiles(
        [file],
        subject: subject,
      );
      
      // Track share usage
      await Analytics.track(AnalyticsEvent.shareUsed, {
        'content_type': 'file',
      });
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
      await Share.shareXFiles(
        [image],
        subject: subject,
      );
      
      // Track share usage
      await Analytics.track(AnalyticsEvent.shareUsed, {
        'content_type': 'image',
      });
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
      // Create a temporary file for the image
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/shared_image_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(imageBytes);

      final image = XFile(tempFile.path);
      await Share.shareXFiles(
        [image],
        subject: subject,
      );

      // Clean up the temporary file after a short delay
      Future.delayed(const Duration(seconds: 5), () {
        if (tempFile.existsSync()) {
          tempFile.delete().catchError((e) {
            developer.log(
              'Error deleting temporary image file: $e',
              name: 'SharePlusService.shareImageBytes',
            );
          });
        }
      });
      
      // Track share usage
      await Analytics.track(AnalyticsEvent.shareUsed, {
        'content_type': 'image',
      });
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

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

const channelPasteToApp = 'lucidclip/paste_to_app';

abstract class PasteToAppService {
  Future<bool> checkAccessibilityPermission();

  Future<bool> requestAccessibilityPermission();

  Future<bool> pasteToApp(String bundleId);
}

@LazySingleton(as: PasteToAppService)
class MethodChannelPasteToAppService implements PasteToAppService {
  static const MethodChannel _channel = MethodChannel(channelPasteToApp);

  @override
  Future<bool> checkAccessibilityPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'checkAccessibilityPermission',
      );

      log('Accessibility permission check result: $result');
      return result ?? false;
    } catch (e, stack) {
      log(
        'Error checking accessibility permission: $e',
        name: 'MethodChannelPasteToAppService.checkAccessibilityPermission',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<bool> requestAccessibilityPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'requestAccessibilityPermission',
      );
      log('Accessibility permission request result: $result');

      return result ?? false;
    } catch (e, stack) {
      log(
        'Error requesting accessibility permission: $e',
        name: 'MethodChannelPasteToAppService.requestAccessibilityPermission',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<bool> pasteToApp(String bundleId) async {
    try {
      final result = await _channel.invokeMethod<bool>('pasteToFrontmostApp', {
        'bundleId': bundleId,
      });
      log('Pasting to app with bundleId: $bundleId with result: $result');
      return result ?? false;
    } catch (e, stack) {
      log(
        'Error pasting to app: $e',
        name: 'MethodChannelPasteToAppService.pasteToApp',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }
}

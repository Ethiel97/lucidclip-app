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
      final result = await _channel.invokeMethod<bool>('checkAccessibilityPermission');
      return result ?? false;
    } catch (e, stack) {
      log(
        'MethodChannelPasteToAppService',
        name: 'checkAccessibilityPermission',
        error: 'Error checking accessibility permission: $e',
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<bool> requestAccessibilityPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestAccessibilityPermission');
      return result ?? false;
    } catch (e, stack) {
      log(
        'MethodChannelPasteToAppService',
        name: 'requestAccessibilityPermission',
        error: 'Error requesting accessibility permission: $e',
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<bool> pasteToApp(String bundleId) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'pasteToFrontmostApp',
        {'bundleId': bundleId},
      );
      return result ?? false;
    } catch (e, stack) {
      log(
        'MethodChannelPasteToAppService',
        name: 'pasteToApp',
        error: 'Error pasting to app: $e',
        stackTrace: stack,
      );
      return false;
    }
  }
}

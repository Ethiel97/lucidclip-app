import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

const _channelAccessibility = 'lucidclip/accessibility';

abstract class AccessibilityDataSource {
  Future<bool> checkPermission();
  Future<bool> requestPermission();
}

@LazySingleton(as: AccessibilityDataSource)
class MethodChannelAccessibilityDataSource implements AccessibilityDataSource {
  static const MethodChannel _channel = MethodChannel(_channelAccessibility);

  @override
  Future<bool> checkPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkAccessibility');
      return result ?? false;
    } catch (e, stack) {
      log(
        'Error checking accessibility permission: $e',
        name: 'MethodChannelAccessibilityDataSource.checkPermission',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestAccessibility');
      return result ?? false;
    } catch (e, stack) {
      log(
        'Error requesting accessibility permission: $e',
        name: 'MethodChannelAccessibilityDataSource.requestPermission',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }
}

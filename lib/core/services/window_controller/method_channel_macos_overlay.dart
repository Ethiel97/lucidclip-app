import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/services/services.dart';

@LazySingleton(as: MacosOverlay)
class MethodChannelMacosOverlay implements MacosOverlay {
  static const _channel = MethodChannel('lucidclip/window_overlay');

  @override
  Future<void> setFullscreenOverlay({bool enabled = true}) async {
    try {
      await _channel.invokeMethod('setFullscreenOverlay', {'enabled': enabled});
      log('setFullscreenOverlay($enabled) OK', name: 'MacosOverlay');
    } catch (e, st) {
      log(
        'setFullscreenOverlay($enabled) FAILED: $e',
        name: 'MacosOverlay',
        stackTrace: st,
      );
      // rethrow;
    }
  }

  @override
  Future<void> activateApp() async {
    try {
      await _channel.invokeMethod('activateApp');
      log('activateApp OK', name: 'MacosOverlay');
    } catch (e, st) {
      log('activateApp FAILED: $e', name: 'MacosOverlay', stackTrace: st);
      rethrow;
    }
  }
}

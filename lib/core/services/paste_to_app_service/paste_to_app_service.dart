import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

const channelPasteToApp = 'lucidclip/paste_to_app';

//ignore: one_member_abstracts
abstract class PasteToAppService {
  Future<bool> pasteToApp(String bundleId);
}

@LazySingleton(as: PasteToAppService)
class MethodChannelPasteToAppService implements PasteToAppService {
  static const MethodChannel _channel = MethodChannel(channelPasteToApp);

  @override
  Future<bool> pasteToApp(String bundleId) async {
    try {
      final result = await _channel.invokeMethod<bool>('pasteToFrontmostApp', {
        'bundleId': bundleId,
      });
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

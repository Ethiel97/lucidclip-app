import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';

const channelFrontmostApp = 'lucidclip/frontmost_app';

@LazySingleton(as: SourceAppProvider)
class MethodChannelSourceAppProvider implements SourceAppProvider {
  static const MethodChannel _channel = MethodChannel(channelFrontmostApp);

  @override
  Future<SourceApp?> getFrontmostApp() async {
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('get');
      if (res == null) return null;

      final data = Map<String, dynamic>.from(res);
      final app = SourceAppModel.fromJson(data).toEntity();
      return app.isValid ? app : null;
    } catch (e, stack) {
      log(
        'MethodChannelSourceAppProvider',
        name: 'getFrontmostApp',
        error: 'Error getting frontmost app: $e',
        stackTrace: stack,
      );

      return null;
    }
  }
}

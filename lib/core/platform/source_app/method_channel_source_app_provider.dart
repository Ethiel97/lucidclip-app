// lib/core/platform/source_app/method_channel_source_app_provider.dart
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';

@LazySingleton(as: SourceAppProvider)
class MethodChannelSourceAppProvider implements SourceAppProvider {
  static const MethodChannel _channel = MethodChannel(
    'lucidclip/frontmost_app',
  );

  @override
  Future<SourceApp?> getFrontmostApp() async {
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('get');
      if (res == null) return null;

      final app = SourceApp.fromMap(res);
      return app.isValid ? app : null;
    } catch (_) {
      return null;
    }
  }
}

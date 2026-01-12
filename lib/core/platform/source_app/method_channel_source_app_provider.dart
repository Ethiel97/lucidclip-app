import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';

const channelFrontmostApp = 'lucidclip/frontmost_app';

@LazySingleton(as: SourceAppProvider)
class MethodChannelSourceAppProvider implements SourceAppProvider {
  MethodChannelSourceAppProvider(
    @Named('sourceAppCache') this._sourceAppCache,
    @Named('iconCache') this._iconCache,
  );

  static const MethodChannel _channel = MethodChannel(channelFrontmostApp);
  final CacheService<SourceAppModel> _sourceAppCache;
  final CacheService<Uint8List> _iconCache;

  @override
  Future<SourceApp?> getFrontmostApp() async {
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('get');
      if (res == null) return null;

      final data = Map<String, dynamic>.from(res);
      final bundleId = data['bundle_id'] as String;

      // 1. Gérer l'icône EN PREMIER (avant de récupérer l'app du cache)
      if (data['icon'] != null) {
        final cachedIcon = await _iconCache.get(bundleId);
        if (cachedIcon == null) {
          final icon = base64Decode(data['icon'] as String);
          await _iconCache.put(
            key: bundleId,
            data: icon,
            ttl: const Duration(days: 7),
          );
        }
      }

      // 2. Maintenant récupérer l'app (l'icône sera chargée par onDeserialize)
      var appModel = await _sourceAppCache.get(bundleId);

      if (appModel == null) {
        appModel = SourceAppModel(
          bundleId: bundleId,
          name: data['name'] as String,
        );

        await _sourceAppCache.put(
          key: bundleId,
          data: appModel,
          ttl: const Duration(days: 30),
        );

        // Recharger pour que onDeserialize s'exécute
        appModel = await _sourceAppCache.get(bundleId);
      }

      final app = appModel?.toEntity();
      return app?.isValid ?? false ? app : null;
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

import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';

/// Service pour récupérer les icônes des applications sources
@lazySingleton
class SourceAppIconService {
  SourceAppIconService({
    @Named('iconCache') required CacheService<Uint8List> iconCache,
    @Named('sourceAppCache')
    required CacheService<SourceAppModel> sourceAppCache,
  }) : _iconCache = iconCache,
       _sourceAppCache = sourceAppCache;

  final CacheService<Uint8List> _iconCache;
  final CacheService<SourceAppModel> _sourceAppCache;

  /// Gets an icon from cache by bundleId
  Future<Uint8List?> getIcon(String bundleId) async {
    return _iconCache.get(bundleId);
  }

  /// Gets a SourceApp with its icon from cache
  Future<SourceApp?> getSourceAppWithIcon(String bundleId) async {
    final cachedApp = await _sourceAppCache.get(bundleId);
    if (cachedApp == null) return null;

    // Retourne le SourceApp (l'icône est déjà chargée par le serializer)
    return cachedApp.toEntity();
  }

  /// Enriches a SourceApp with its icon if not already present
  Future<SourceApp> enrichWithIcon(SourceApp app) async {
    if (app.icon != null) return app;
    final icon = await getIcon(app.bundleId);

    if (icon == null) return app;
    return app.copyWith(icon: icon);
  }
}

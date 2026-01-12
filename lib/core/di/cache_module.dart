import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';

@module
abstract class CacheModule {
  // Serializers de base
  @lazySingleton
  CacheSerializer<String, List<int>> stringBytesSerializer() {
    return const StringBytesSerializer();
  }

  @lazySingleton
  CacheSerializer<Uint8List, List<int>> uint8ListBytesSerializer() {
    return const Uint8ListToListIntSerializer();
  }

  @lazySingleton
  CacheSerializer<SourceAppModel, String> sourceAppJsonSerializer(
    @Named('iconCache') CacheService<Uint8List> iconCache,
  ) {
    return JsonSerializer<SourceAppModel>(
      fromJson: SourceAppModel.fromJson,
      toJson: (app) => app.toJson(),
      onDeserialize: (app) async {
        final icon = await iconCache.get(app.bundleId);
        return app.copyWith(icon: icon);
      },
    );
  }

  // Cache pour icônes - UNIQUE
  @lazySingleton
  @Named('iconCache')
  CacheService<Uint8List> iconCache(
    CacheSerializer<Uint8List, List<int>> serializer,
  ) {
    return DiskCacheService<Uint8List, List<int>>(
      serializer: serializer,
      fileSerializer: serializer,
      cacheDirectory: 'app_icons',
    );
  }

  // Cache pour SourceAppModel
  @lazySingleton
  @Named('sourceAppCache')
  CacheService<SourceAppModel> sourceAppCache(
    CacheSerializer<SourceAppModel, String> jsonSerializer,
    CacheSerializer<String, List<int>> bytesSerializer,
  ) {
    return DiskCacheService<SourceAppModel, String>(
      serializer: jsonSerializer,
      fileSerializer: bytesSerializer,
      cacheDirectory: 'source_apps',
    );
  }
}

import 'dart:io';

import 'package:lucid_clip/core/services/cache_service/cache_service.dart';
import 'package:path_provider/path_provider.dart';

class DiskCacheService<T, S> implements CacheService<T> {
  DiskCacheService({
    required this.serializer,
    required this.fileSerializer,
    this.cacheDirectory = 'app_cache',
  });

  final CacheSerializer<T, S> serializer;
  final CacheSerializer<S, List<int>> fileSerializer;
  final String cacheDirectory;

  Future<String> _getCachePath() async {
    final dir = await getApplicationSupportDirectory();
    final cacheDir = Directory('${dir.path}/$cacheDirectory');
    if (!cacheDir.existsSync()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir.path;
  }

  String _getCacheFileName(String key) => '${key.hashCode}.cache';

  @override
  Future<void> put({
    required String key,
    required T data,
    Duration? ttl,
  }) async {
    final path = await _getCachePath();
    final file = File('$path/${_getCacheFileName(key)}');

    final serialized = await serializer.serialize(data);
    final bytes = await fileSerializer.serialize(serialized);

    await file.writeAsBytes(bytes);

    if (ttl != null) {
      final metaFile = File('$path/${_getCacheFileName(key)}.meta');
      final expiry = DateTime.now().toUtc().add(ttl).millisecondsSinceEpoch;
      await metaFile.writeAsString('$expiry');
    }
  }

  @override
  Future<T?> get(String key) async {
    try {
      final path = await _getCachePath();
      final file = File('$path/${_getCacheFileName(key)}');

      if (!file.existsSync()) return null;

      final metaFile = File('$path/${_getCacheFileName(key)}.meta');
      if (metaFile.existsSync()) {
        final expiryStr = await metaFile.readAsString();
        final expiry = int.parse(expiryStr);
        if (DateTime.now().toUtc().millisecondsSinceEpoch > expiry) {
          await remove(key);
          return null;
        }
      }

      final bytes = await file.readAsBytes();
      final serialized = await fileSerializer.deserialize(bytes);
      return await serializer.deserialize(serialized);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    final path = await _getCachePath();
    final file = File('$path/${_getCacheFileName(key)}');
    final metaFile = File('$path/${_getCacheFileName(key)}.meta');

    if (file.existsSync()) await file.delete();
    if (metaFile.existsSync()) await metaFile.delete();
  }

  @override
  Future<void> clear() async {
    final path = await _getCachePath();
    final dir = Directory(path);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  @override
  Future<bool> contains(String key) async {
    final data = await get(key);
    return data != null;
  }
}

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

@LazySingleton(as: LocalClipboardRepository)
class LocalClipboardStoreImpl implements LocalClipboardRepository {
  LocalClipboardStoreImpl(this._localDataSource);

  final ClipboardLocalDataSource _localDataSource;

  @override
  Future<void> upsert(ClipboardItem item) async {
    try {
      final existing =
          await _localDataSource.getByContentHash(item.contentHash);
      if (existing != null && existing.id != item.id) {
        return;
      }
      await _localDataSource.put(ClipboardItemModel.fromEntity(item));
    } catch (e) {
      throw CacheException('Failed to upsert clipboard item: $e');
    }
  }

  @override
  Future<void> upsertBatch(List<ClipboardItem> items) async {
    try {
      if (items.isEmpty) return;

      final existingHashes = await _localDataSource.getAllContentHashes();

      final toInsert = <ClipboardItemModel>[];
      for (final item in items) {
        if (!existingHashes.contains(item.contentHash)) {
          toInsert.add(ClipboardItemModel.fromEntity(item));
          existingHashes.add(item.contentHash);
        }
      }

      await _localDataSource.putAll(toInsert);
    } catch (e) {
      throw CacheException('Failed to upsert clipboard items batch: $e');
    }
  }

  @override
  Future<ClipboardItem?> getById(String id) async {
    try {
      final record = await _localDataSource.getById(id);
      return record?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get clipboard item by id: $e');
    }
  }

  @override
  Future<ClipboardItem?> getByContentHash(String contentHash) async {
    try {
      final record = await _localDataSource.getByContentHash(contentHash);
      return record?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get clipboard item by content hash: $e');
    }
  }

  @override
  Future<List<ClipboardItem>> getAll() async {
    try {
      final records = await _localDataSource.getAll();
      return records.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get all clipboard items: $e');
    }
  }

  @override
  Future<List<ClipboardItem>> getUnsynced() async {
    try {
      final records = await _localDataSource.getUnsynced();
      return records.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get unsynced clipboard items: $e');
    }
  }

  @override
  Future<void> markAsSynced(List<String> ids) async {
    try {
      for (final id in ids) {
        await _localDataSource.updateSyncStatus(id, isSynced: true);
      }
    } catch (e) {
      throw CacheException('Failed to mark clipboard items as synced: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _localDataSource.deleteById(id);
    } catch (e) {
      throw CacheException('Failed to delete clipboard item by id: $e');
    }
  }

  @override
  Future<void> deleteByContentHash(String contentHash) async {
    try {
      await _localDataSource.deleteByContentHash(contentHash);
    } catch (e) {
      throw CacheException(
        'Failed to delete clipboard item by content hash: $e',
      );
    }
  }

  @override
  Stream<List<ClipboardItem>> watchAll() {
    try {
      return _localDataSource
          .watchAll()
          .map((records) => records.map((r) => r.toEntity()).toList());
    } catch (e) {
      throw CacheException('Failed to watch all clipboard items: $e');
    }
  }

  @disposeMethod
  @override
  Future<void> clear() async {
    await _localDataSource.clear();
  }
}

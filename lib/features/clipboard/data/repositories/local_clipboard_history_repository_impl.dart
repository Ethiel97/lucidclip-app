import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

@LazySingleton(as: LocalClipboardHistoryRepository)
class LocalClipboardHistoryStoreImpl
    implements LocalClipboardHistoryRepository {
  LocalClipboardHistoryStoreImpl(this._localDataSource);

  final ClipboardHistoryLocalDataSource _localDataSource;

  @override
  Future<void> upsert(ClipboardHistory history) async {
    try {
      await _localDataSource.put(ClipboardHistoryModel.fromEntity(history));
    } catch (e) {
      throw CacheException('Failed to upsert clipboard history: $e');
    }
  }

  @override
  Future<void> upsertBatch(List<ClipboardHistory> histories) async {
    try {
      if (histories.isEmpty) return;
      final models = histories
          .map(ClipboardHistoryModel.fromEntity)
          .toList();
      await _localDataSource.putAll(models);
    } catch (e) {
      throw CacheException('Failed to upsert clipboard histories batch: $e');
    }
  }

  @override
  Future<ClipboardHistory?> getById(String id) async {
    try {
      final record = await _localDataSource.getById(id);
      return record?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get clipboard history by id: $e');
    }
  }

  @override
  Future<List<ClipboardHistory>> getByClipboardItemId(
    String clipboardItemId,
  ) async {
    try {
      final records =
          await _localDataSource.getByClipboardItemId(clipboardItemId);
      return records.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw CacheException(
        'Failed to get clipboard history by clipboard item id: $e',
      );
    }
  }

  @override
  Future<List<ClipboardHistory>> getAll() async {
    try {
      final records = await _localDataSource.getAll();
      return records.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get all clipboard histories: $e');
    }
  }

  @override
  Future<List<ClipboardHistory>> getByAction(ClipboardAction action) async {
    try {
      final records = await _localDataSource.getByAction(action.name);
      return records.map((r) => r.toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get clipboard history by action: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _localDataSource.deleteById(id);
    } catch (e) {
      throw CacheException('Failed to delete clipboard history by id: $e');
    }
  }

  @override
  Future<void> deleteByClipboardItemId(String clipboardItemId) async {
    try {
      await _localDataSource.deleteByClipboardItemId(clipboardItemId);
    } catch (e) {
      throw CacheException(
        'Failed to delete clipboard history by clipboard item id: $e',
      );
    }
  }

  @override
  Stream<List<ClipboardHistory>> watchAll() {
    try {
      return _localDataSource
          .watchAll()
          .map((records) => records.map((r) => r.toEntity()).toList());
    } catch (e) {
      throw CacheException('Failed to watch all clipboard histories: $e');
    }
  }

  @disposeMethod
  @override
  Future<void> clear() async {
    await _localDataSource.clear();
  }
}

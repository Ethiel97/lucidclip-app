// dart
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';

@LazySingleton(as: ClipboardLocalDataSource)
class DriftClipboardLocalDataSource implements ClipboardLocalDataSource {
  const DriftClipboardLocalDataSource(this._db);

  final ClipboardDatabase _db;

  @override
  Future<void> put(ClipboardItemModel item) async {
    try {
      await _db.transaction(() async {
        final comp = _db.modelToCompanion(item);
        await _db.upsertItem(comp);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> putAll(List<ClipboardItemModel> items) async {
    try {
      if (items.isEmpty) return;

      await _db.transaction(() async {
        final comps = items.map(_db.modelToCompanion).toList();
        await _db.upsertItemsBatch(comps);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ClipboardItemModel?> getById(String id) async {
    try {
      final row = await _db.getById(id);
      return row == null ? null : _db.entryToModel(row);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ClipboardItemModel?> getByContentHash(String contentHash) async {
    try {
      final row = await _db.getByContentHash(contentHash);
      return row == null ? null : _db.entryToModel(row);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardItemModel>> getAll() async {
    try {
      final rows = await _db.getAllEntries();
      return rows.map(_db.entryToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Set<String>> getAllContentHashes() => _db.getAllContentHashes();

  @override
  Future<List<ClipboardItemModel>> getUnsynced() async {
    try {
      final rows = await _db.getUnsyncedEntries();
      return rows.map(_db.entryToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSyncStatus(String id, {required bool isSynced}) async {
    try {
      await _db.transaction(() async {
        await _db.updateSyncStatus(id, isSynced: isSynced);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String id) async {
    try {
      await _db.transaction(() async {
        await _db.deleteById(id);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteByContentHash(String contentHash) async {
    try {
      await _db.transaction(() async {
        await _db.deleteByContentHash(contentHash);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ClipboardItemModel>> watchAll() {
    try {
      return _db.watchAllEntries().distinct().map(
        (rows) => rows.map(_db.entryToModel).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @disposeMethod
  @override
  Future<void> clear() => _db.clearAll();
}

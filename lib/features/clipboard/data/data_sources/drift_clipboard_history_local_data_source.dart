// dart
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';

@LazySingleton(as: ClipboardHistoryLocalDataSource)
class DriftClipboardHistoryLocalDataSource
    implements ClipboardHistoryLocalDataSource {
  const DriftClipboardHistoryLocalDataSource(this._db);

  final ClipboardDatabase _db;

  @override
  Future<void> put(ClipboardHistoryModel history) async {
    try {
      final comp = _historyModelToCompanion(history);
      await _db.upsertHistory(comp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> putAll(List<ClipboardHistoryModel> histories) async {
    try {
      if (histories.isEmpty) return;
      final comps = histories.map(_historyModelToCompanion).toList();
      await _db.upsertHistoriesBatch(comps);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ClipboardHistoryModel?> getById(String id) async {
    try {
      final row = await _db.getHistoryById(id);
      return row == null ? null : _historyEntryToModel(row);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardHistoryModel>> getByClipboardItemId(
    String clipboardItemId,
  ) async {
    try {
      final rows = await _db.getHistoriesByClipboardItemId(clipboardItemId);
      return rows.map(_historyEntryToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardHistoryModel>> getAll() async {
    try {
      final rows = await _db.getAllHistories();
      return rows.map(_historyEntryToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardHistoryModel>> getByAction(String action) async {
    try {
      final rows = await _db.getHistoriesByAction(action);
      return rows.map(_historyEntryToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String id) {
    try {
      return _db.deleteHistoryById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteByClipboardItemId(String clipboardItemId) {
    try {
      return _db.deleteHistoriesByClipboardItemId(clipboardItemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ClipboardHistoryModel>> watchAll() {
    try {
      return _db
          .watchAllHistories()
          .map((rows) => rows.map(_historyEntryToModel).toList());
    } catch (e) {
      rethrow;
    }
  }

  @disposeMethod
  @override
  Future<void> clear() => _db.clearAllHistories();

  // Helper methods for mapping

  ClipboardHistoryModel _historyEntryToModel(ClipboardHistoryEntry entry) {
    ClipboardActionModel? action;
    try {
      action = ClipboardActionModel.values.firstWhere(
        (v) => v.name == entry.action,
      );
    } catch (e) {
      developer.log(
        'Enum mismatch: action "${entry.action}" from database not found in ClipboardActionModel. Using copy as fallback.',
        name: 'DriftClipboardHistoryLocalDataSource',
        level: 900, // WARNING: 900 is standard warning level in dart:developer
      );
      action = ClipboardActionModel.copy;
    }

    return ClipboardHistoryModel(
      id: entry.id,
      clipboardItemId: entry.clipboardItemId,
      userId: entry.userId,
      action: action,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  ClipboardHistoryEntriesCompanion _historyModelToCompanion(
    ClipboardHistoryModel model,
  ) {
    return ClipboardHistoryEntriesCompanion(
      id: Value(model.id),
      clipboardItemId: Value(model.clipboardItemId),
      userId: Value(model.userId),
      action: Value(model.action.name),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
    );
  }
}

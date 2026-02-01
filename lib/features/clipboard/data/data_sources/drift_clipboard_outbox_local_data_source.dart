import 'dart:convert';
import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';

@LazySingleton(as: ClipboardOutboxLocalDataSource)
class DriftClipboardOutboxLocalDataSource
    implements ClipboardOutboxLocalDataSource {
  const DriftClipboardOutboxLocalDataSource(this._db);

  final ClipboardDatabase _db;

  @override
  Future<void> enqueue(ClipboardOutboxModel op) async {
    try {
      await _db.upsertOutbox(_modelToCompanion(op));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> enqueueAll(List<ClipboardOutboxModel> ops) async {
    try {
      if (ops.isEmpty) return;
      await _db.upsertOutboxBatch(ops.map(_modelToCompanion).toList());
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ClipboardOutboxModel?> getById(String operationId) async {
    try {
      final row = await _db.getOutboxById(operationId);
      return row == null ? null : _entryToModel(row);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardOutboxModel>> getByEntityId(String entityId) async {
    try {
      final rows = await _db.getOutboxesByEntityId(entityId);
      return rows.map(_entryToModel).toList(growable: false);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardOutboxModel>> getAll({int? limit}) async {
    try {
      final rows = await _db.getAllOutboxes(limit: limit);
      return rows.map(_entryToModel).toList(growable: false);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardOutboxModel>> getPending({int? limit}) async {
    try {
      final rows = await _db.getPendingOutboxes(limit: limit);
      return rows.map(_entryToModel).toList(growable: false);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ClipboardOutboxModel>> getByOperationType(
    String operationType, {
    int? limit,
  }) async {
    try {
      final rows = await _db.getOutboxesByOperationType(
        operationType,
        limit: limit,
      );
      return rows.map(_entryToModel).toList(growable: false);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Stream<List<ClipboardOutboxModel>> watchAll({int? limit}) {
    try {
      return _db
          .watchOutboxes(limit: limit)
          .map((rows) => rows.map(_entryToModel).toList(growable: false));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> markSent(String operationId, {required DateTime sentAt}) async {
    try {
      await _db.markOutboxSent(operationId, sentAt);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> markFailed(String operationId, {required String error}) async {
    try {
      await _db.markOutboxFailed(operationId, error);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> incrementRetry(String operationId) async {
    try {
      await _db.incrementOutboxRetry(operationId);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String operationId) async {
    try {
      await _db.deleteOutboxById(operationId);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteByEntityId(String entityId) async {
    try {
      await _db.deleteOutboxesByEntityId(entityId);
    } catch (_) {
      rethrow;
    }
  }

  @disposeMethod
  @override
  Future<void> clear() => _db.clearOutbox();

  // ----------------
  // Mapping helpers
  // ----------------

  ClipboardOutboxModel _entryToModel(ClipboardOutboxEntry entry) {
    final opType = _parseOperationType(entry.operationType);

    final payload = entry.payload != null
        ? jsonDecode(entry.payload!) as Map<String, dynamic>
        : null;

    return ClipboardOutboxModel(
      id: entry.operationId,
      entityId: entry.entityId,
      userId: entry.userId,
      operationType: opType,
      createdAt: entry.createdAt,

      payload: payload,
      deviceId: entry.deviceId,
      sentAt: entry.sentAt,
      retryCount: entry.retryCount,
      lastError: entry.lastError,
    );
  }

  ClipboardOutboxEntriesCompanion _modelToCompanion(
    ClipboardOutboxModel model,
  ) {
    final payload = model.payload != null ? jsonEncode(model.payload) : null;
    return ClipboardOutboxEntriesCompanion(
      operationId: Value(model.id),
      entityId: Value(model.entityId),
      userId: Value(model.userId),
      operationType: Value(model.operationType.name),
      createdAt: Value(model.createdAt),

      payload: Value(payload),
      deviceId: Value(model.deviceId),
      sentAt: Value(model.sentAt),
      retryCount: Value(model.retryCount),
      lastError: Value(model.lastError),
    );
  }

  ClipboardOperationTypeModel _parseOperationType(String raw) {
    try {
      return ClipboardOperationTypeModel.values.firstWhere(
        (v) => v.name == raw,
      );
    } catch (_) {
      developer.log(
        'Enum mismatch: operationType "$raw" not found. Using "unknown".',
        name: 'DriftClipboardOutboxLocalDataSource',
        level: 900,
      );
      return ClipboardOperationTypeModel.unknown;
    }
  }
}

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

@LazySingleton(as: LocalClipboardOutboxRepository)
class LocalClipboardOutboxImpl implements LocalClipboardOutboxRepository {
  LocalClipboardOutboxImpl(this._localDataSource);

  final ClipboardOutboxLocalDataSource _localDataSource;

  @override
  Future<void> enqueue(ClipboardOutbox op) async {
    try {
      await _localDataSource.enqueue(ClipboardOutboxModel.fromEntity(op));
    } catch (e) {
      throw CacheException('Failed to enqueue outbox op: $e');
    }
  }

  @override
  Future<void> enqueueBatch(List<ClipboardOutbox> ops) async {
    try {
      if (ops.isEmpty) return;
      final models = ops.map(ClipboardOutboxModel.fromEntity).toList();
      await _localDataSource.enqueueAll(models);
    } catch (e) {
      throw CacheException('Failed to enqueue outbox ops batch: $e');
    }
  }

  @override
  Future<ClipboardOutbox?> getById(String operationId) async {
    try {
      final record = await _localDataSource.getById(operationId);
      return record?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get outbox op by id: $e');
    }
  }

  @override
  Future<List<ClipboardOutbox>> getByEntityId(String entityId) async {
    try {
      final records = await _localDataSource.getByEntityId(entityId);
      return records.map((r) => r.toEntity()).toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to get outbox ops by entityId: $e');
    }
  }

  @override
  Future<List<ClipboardOutbox>> getPending({int? limit}) async {
    try {
      final records = await _localDataSource.getPending(limit: limit);
      return records.map((r) => r.toEntity()).toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to get pending outbox ops: $e');
    }
  }

  @override
  Future<List<ClipboardOutbox>> getAll({int? limit}) async {
    try {
      final records = await _localDataSource.getAll(limit: limit);
      return records.map((r) => r.toEntity()).toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to get all outbox ops: $e');
    }
  }

  @override
  Future<List<ClipboardOutbox>> getByOperationType(
    ClipboardOperationType operationType, {
    int? limit,
  }) async {
    try {
      final records = await _localDataSource.getByOperationType(
        operationType.name,
        limit: limit,
      );
      return records.map((r) => r.toEntity()).toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to get outbox ops by operation type: $e');
    }
  }

  @override
  Future<void> markSent(String operationId, {required DateTime sentAt}) async {
    try {
      await _localDataSource.markSent(operationId, sentAt: sentAt);
    } catch (e) {
      throw CacheException('Failed to mark outbox op as sent: $e');
    }
  }

  @override
  Future<void> markFailed(String operationId, {required String error}) async {
    try {
      await _localDataSource.markFailed(operationId, error: error);
    } catch (e) {
      throw CacheException('Failed to mark outbox op as failed: $e');
    }
  }

  @override
  Future<void> incrementRetry(String operationId) async {
    try {
      await _localDataSource.incrementRetry(operationId);
    } catch (e) {
      throw CacheException('Failed to increment outbox retry: $e');
    }
  }

  @override
  Future<void> deleteById(String operationId) async {
    try {
      await _localDataSource.deleteById(operationId);
    } catch (e) {
      throw CacheException('Failed to delete outbox op by id: $e');
    }
  }

  @override
  Future<void> deleteByEntityId(String entityId) async {
    try {
      await _localDataSource.deleteByEntityId(entityId);
    } catch (e) {
      throw CacheException('Failed to delete outbox ops by entityId: $e');
    }
  }

  @disposeMethod
  @override
  Future<void> clear() async {
    await _localDataSource.clear();
  }
}

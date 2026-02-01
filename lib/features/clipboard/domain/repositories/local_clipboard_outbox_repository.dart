import 'package:lucid_clip/features/clipboard/clipboard.dart';

abstract class LocalClipboardOutboxRepository {
  /// Enqueue / upsert a single operation
  Future<void> enqueue(ClipboardOutbox op);

  /// Enqueue / upsert multiple operations
  Future<void> enqueueBatch(List<ClipboardOutbox> ops);

  Future<ClipboardOutbox?> getById(String operationId);

  Future<List<ClipboardOutbox>> getByEntityId(String entityId);

  Future<List<ClipboardOutbox>> getPending({int? limit});

  /// Debug / admin only
  Future<List<ClipboardOutbox>> getAll({int? limit});

  Future<List<ClipboardOutbox>> getByOperationType(
    ClipboardOperationType operationType, {
    int? limit,
  });

  /// Mark op as sent (ack remote)
  Future<void> markSent(String operationId, {required DateTime sentAt});

  /// Mark op as failed (kept for retry)
  Future<void> markFailed(String operationId, {required String error});

  Future<void> incrementRetry(String operationId);

  Future<void> deleteById(String operationId);

  Future<void> deleteByEntityId(String entityId);

  Future<void> clear();
}

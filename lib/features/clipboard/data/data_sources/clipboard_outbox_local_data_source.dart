import 'package:lucid_clip/features/clipboard/data/data.dart';

abstract class ClipboardOutboxLocalDataSource {
  /// Enqueue / upsert an outbox operation
  Future<void> enqueue(ClipboardOutboxModel op);

  Future<void> enqueueAll(List<ClipboardOutboxModel> ops);

  Future<ClipboardOutboxModel?> getById(String operationId);

  Future<List<ClipboardOutboxModel>> getByEntityId(String entityId);

  Future<List<ClipboardOutboxModel>> getAll({int? limit});

  /// Pending = not sent yet (sentAt == null) or status pending
  Future<List<ClipboardOutboxModel>> getPending({int? limit});

  Future<List<ClipboardOutboxModel>> getByOperationType(
    String operationType, {
    int? limit,
  });

  Stream<List<ClipboardOutboxModel>> watchAll({int? limit});

  Future<void> markSent(String operationId, {required DateTime sentAt});

  Future<void> markFailed(String operationId, {required String error});

  Future<void> incrementRetry(String operationId);

  Future<void> deleteById(String operationId);

  Future<void> deleteByEntityId(String entityId);

  Future<void> clear();
}

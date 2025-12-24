import 'package:lucid_clip/features/clipboard/clipboard.dart';

/// Contract for local storage of clipboard history records.
/// Implemented by the data layer (Hive, Isar, SQLite, etc.)
abstract class LocalClipboardHistoryRepository {
  /// Upsert a single clipboard history record
  Future<void> upsert(ClipboardHistory history);

  /// Upsert multiple clipboard history records
  Future<void> upsertBatch(List<ClipboardHistory> histories);

  /// Get a clipboard history record by ID
  Future<ClipboardHistory?> getById(String id);

  /// Get all clipboard history records for a specific clipboard item
  Future<List<ClipboardHistory>> getByClipboardItemId(String clipboardItemId);

  /// Get all clipboard history records
  Future<List<ClipboardHistory>> getAll();

  /// Get clipboard history records for a specific action
  Future<List<ClipboardHistory>> getByAction(ClipboardAction action);

  /// Delete a clipboard history record by ID
  Future<void> delete(String id);

  /// Delete all clipboard history records for a specific clipboard item
  Future<void> deleteByClipboardItemId(String clipboardItemId);

  /// Watch all clipboard history records
  Stream<List<ClipboardHistory>> watchAll();

  /// Clear all clipboard history records
  Future<void> clear();
}

import 'package:lucid_clip/features/clipboard/clipboard.dart';

/// Contrat pour le stockage local des items clipboard.
/// Implémenté par la couche data (Hive, Isar, SQLite, etc.)
abstract class LocalClipboardRepository {
  Future<void> upsert(ClipboardItem item);

  Future<void> upsertBatch(List<ClipboardItem> items);

  Future<ClipboardItem?> getById(String id);

  Future<ClipboardItem?> getByContentHash(String contentHash);

  Future<List<ClipboardItem>> getAll();

  Future<List<ClipboardItem>> getUnsynced();

  Future<void> markAsSynced(List<String> ids);

  Future<void> delete(String id);

  Future<void> deleteByContentHash(String contentHash);

  Stream<List<ClipboardItem>> watchAll();

  Future<void> clear();
}

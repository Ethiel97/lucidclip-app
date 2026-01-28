import 'package:lucid_clip/features/clipboard/clipboard.dart';

/// Contrat pour le stockage local des items clipboard.
/// Implémenté par la couche data (Hive, Isar, SQLite, etc.)
///
///

enum FetchMode {
  withIcons,
  withoutIcons;

  bool get includesIcons => this == FetchMode.withIcons;

  bool get excludesIcons => this == FetchMode.withoutIcons;
}

abstract class LocalClipboardRepository {
  Future<void> upsert(ClipboardItem item);

  Future<void> upsertBatch(List<ClipboardItem> items);

  Future<void> upsertWithLimit({
    required ClipboardItem item,
    required int maxItems,
  });

  Future<ClipboardItem?> getById(String id);

  Future<ClipboardItem?> getByContentHash(String contentHash);

  Future<List<ClipboardItem>> getAll({
    FetchMode fetchMode = FetchMode.withIcons,
  });

  Future<List<ClipboardItem>> getUnsynced({
    FetchMode fetchMode = FetchMode.withIcons,
  });

  Future<void> markAsSynced(List<String> ids);

  Future<void> delete(String id);

  Future<void> deleteByContentHash(String contentHash);

  Stream<List<ClipboardItem>> watchAll({required int limit});

  Future<void> clear();
}

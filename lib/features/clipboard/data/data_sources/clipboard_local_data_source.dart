
import 'package:lucid_clip/features/clipboard/data/data.dart';


abstract class ClipboardLocalDataSource {
  Future<void> put(ClipboardItemModel item);

  Future<void> putAll(List<ClipboardItemModel> items);

  Future<ClipboardItemModel?> getById(String id);

  Future<ClipboardItemModel?> getByContentHash(String contentHash);

  Future<List<ClipboardItemModel>> getAll();

  Future<Set<String>> getAllContentHashes();

  Future<List<ClipboardItemModel>> getUnsynced();

  Future<void> updateSyncStatus(String id, {required bool isSynced});

  Future<void> deleteById(String id);

  Future<void> deleteByContentHash(String contentHash);

  Stream<List<ClipboardItemModel>> watchAll();

  Future<void> clear();
}

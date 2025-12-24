import 'package:lucid_clip/features/clipboard/data/data.dart';

abstract class ClipboardHistoryLocalDataSource {
  Future<void> put(ClipboardHistoryModel history);

  Future<void> putAll(List<ClipboardHistoryModel> histories);

  Future<ClipboardHistoryModel?> getById(String id);

  Future<List<ClipboardHistoryModel>> getByClipboardItemId(
    String clipboardItemId,
  );

  Future<List<ClipboardHistoryModel>> getAll();

  Future<List<ClipboardHistoryModel>> getByAction(String action);

  Future<void> deleteById(String id);

  Future<void> deleteByClipboardItemId(String clipboardItemId);

  Stream<List<ClipboardHistoryModel>> watchAll();

  Future<void> clear();
}

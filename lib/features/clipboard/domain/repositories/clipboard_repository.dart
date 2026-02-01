import 'package:lucid_clip/features/clipboard/clipboard.dart';

abstract class ClipboardRepository {
  Future<void> upsertClipboardItem({required Map<String, dynamic> data});

  Future<void> upsertClipboardItemsBatch({
    required List<Map<String, dynamic>> data,
  });

  Future<List<ClipboardItem>> fetchClipboardItems({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<ClipboardOutboxes> fetchClipboardHistory({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<void> createTag({required Map<String, dynamic> data});

  Future<void> deleteTag({required dynamic value});

  Future<Tags> fetchTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<ClipboardItemTags> fetchClipboardItemTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  //update clipboard item
  Future<void> updateClipboardItem({
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  });

  Stream<List<ClipboardItem>> watchClipboardItems({
    Map<String, dynamic>? filters,
  });

  Future<void> deleteClipboardItem({required dynamic value});
}

import 'package:lucid_clip/features/clipboard/clipboard.dart';



abstract class ClipboardRemoteDataSource {
  Future<void> upsertClipboardItem({
    required Map<String, dynamic> data,
  });

  Future<void> upsertClipboardItemsBatch({
    required List<Map<String, dynamic>> data,
  });

  Future<ClipboardItemModels> fetchClipboardItems({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<void> updateClipboardItem({
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  });

  Future<ClipboardHistoryModels> fetchClipboardHistory({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<void> createTag({
    required Map<String, dynamic> data,
  });

  Future<void> deleteTag({
    required String column,
    required dynamic value,
  });

  Future<TagModels> fetchTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Future<ClipboardItemTagModels> fetchClipboardItemTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Stream<ClipboardItemModels> watchClipboardItems({
    Map<String, dynamic>? filters,
  });

  Future<void> deleteClipboardItem({
    required String column,
    required dynamic value,
  });
}

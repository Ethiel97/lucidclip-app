abstract class ClipboardRepository {
  Future<void> upsertClipboardItem({
    required Map<String, dynamic> data,
  });

  Future<void> upsertClipboardItemsBatch({
    required List<Map<String, dynamic>> data,
  });

  Future<List<Map<String, dynamic>>> fetchClipboardItems({
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

  Stream<List<Map<String, dynamic>>> watchClipboardItems({
    Map<String, dynamic>? filters,
  });

  Future<void> deleteClipboardItem({
    required String column,
    required dynamic value,
  });
}

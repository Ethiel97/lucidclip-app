import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/network/network.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

@LazySingleton(as: ClipboardRemoteDataSource)
class SupabaseRemoteDataSource implements ClipboardRemoteDataSource {
  const SupabaseRemoteDataSource({required RemoteSyncClient networkClient})
    : _networkClient = networkClient;
  static String clipboardItemsTable = 'clipboard_items';

  static String tagsTable = 'tags';

  static String clipboardHistoryTable = 'clipboard_history';

  static String clipboardItemTagsTable = 'clipboard_item_tags';

  final RemoteSyncClient _networkClient;

  @override
  Future<void> deleteClipboardItem({
    required String column,
    required dynamic value,
  }) async {
    try {
      await _networkClient.delete(
        table: clipboardItemsTable,
        column: column,
        value: value,
      );
    } catch (e, stack) {
      throw NetworkException('Failed to delete clipboard item: $e $stack ');
    }
  }

  @override
  Future<ClipboardItemModels> fetchClipboardItems({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final response = await _networkClient.fetch(
        table: clipboardItemsTable,
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(response.map(ClipboardItemModel.fromJson));
    } catch (e, stack) {
      throw NetworkException('Failed to fetch clipboard items: $e $stack');
    }
  }

  @override
  Future<void> updateClipboardItem({
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _networkClient.update(
        table: clipboardItemsTable,
        column: column,
        value: value,
        data: data,
      );
    } catch (e, stack) {
      throw NetworkException('Failed to update clipboard item: $e $stack');
    }
  }

  @override
  Future<void> upsertClipboardItem({required Map<String, dynamic> data}) {
    try {
      return _networkClient.upsert(table: clipboardItemsTable, data: data);
    } catch (e, stack) {
      throw NetworkException('Failed to upsert clipboard item: $e $stack');
    }
  }

  @override
  Future<void> upsertClipboardItemsBatch({
    required List<Map<String, dynamic>> data,
  }) {
    try {
      return _networkClient.upsertBatch(table: clipboardItemsTable, data: data);
    } catch (e, stack) {
      throw NetworkException(
        'Failed to upsert clipboard items batch: $e $stack',
      );
    }
  }

  @override
  Stream<ClipboardItemModels> watchClipboardItems({
    Map<String, dynamic>? filters,
  }) {
    try {
      final response = _networkClient.watch<Map<String, dynamic>>(
        table: clipboardItemsTable,
        filters: filters,
      );

      return response.map(
        (event) =>
            ClipboardItemModels.from(event.map(ClipboardItemModel.fromJson)),
      );
    } catch (e, stack) {
      throw NetworkException('Failed to watch clipboard items: $e $stack');
    }
  }

  @override
  Future<void> createTag({required Map<String, dynamic> data}) async {
    await _networkClient.upsert(table: tagsTable, data: data);
  }

  @override
  Future<void> deleteTag({
    required String column,
    required dynamic value,
  }) async {
    return _networkClient.delete(
      table: tagsTable,
      column: column,
      value: value,
    );
  }

  @override
  Future<ClipboardHistoryModels> fetchClipboardHistory({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final response = await _networkClient.fetch(
        table: clipboardHistoryTable,
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(response.map(ClipboardOutboxModel.fromJson));
    } catch (e) {
      throw NetworkException('Failed to fetch clipboard history: $e');
    }
  }

  @override
  Future<TagModels> fetchTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final response = await _networkClient.fetch(
        table: tagsTable,
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(response.map(TagModel.fromJson));
    } catch (e) {
      throw NetworkException('Failed to fetch tags: $e');
    }
  }

  @override
  Future<ClipboardItemTagModels> fetchClipboardItemTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final response = await _networkClient.fetch(
        table: clipboardItemTagsTable,
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(response.map(ClipboardItemTagModel.fromJson));
    } catch (e) {
      throw NetworkException('Failed to fetch clipboard item tags: $e');
    }
  }
}

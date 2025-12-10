import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

@LazySingleton(as: ClipboardRepository)
class SupabaseRepositoryImpl implements ClipboardRepository {
  SupabaseRepositoryImpl({required this.remoteDataSource});

  final ClipboardRemoteDataSource remoteDataSource;

  @override
  Future<void> deleteClipboardItem({
    required dynamic value,
  }) async {
    try {
      return remoteDataSource.deleteClipboardItem(
        column: 'id',
        value: value,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete clipboard item: $e');
    }
  }

  @override
  Future<ClipboardItems> fetchClipboardItems({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final clipboardItems = await remoteDataSource.fetchClipboardItems(
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(
        clipboardItems.map((item) => item.toEntity()),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch clipboard items: $e');
    }
  }

  @override
  Future<void> updateClipboardItem({
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  }) {
    return remoteDataSource.updateClipboardItem(
      column: column,
      value: value,
      data: data,
    );
  }

  @override
  Future<void> upsertClipboardItem({required Map<String, dynamic> data}) {
    try {
      return remoteDataSource.upsertClipboardItem(data: data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upsert clipboard item: $e');
    }
  }

  @override
  Future<void> upsertClipboardItemsBatch({
    required List<Map<String, dynamic>> data,
  }) {
    try {
      return remoteDataSource.upsertClipboardItemsBatch(data: data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to upsert clipboard items batch: $e');
    }
  }

  @override
  Stream<ClipboardItems> watchClipboardItems({
    Map<String, dynamic>? filters,
  }) {
    try {
      final clipboardItems =
          remoteDataSource.watchClipboardItems(filters: filters);

      return clipboardItems.map((clipboardItems) {
        return List.from(
          clipboardItems.map((item) => item.toEntity()),
        );
      });
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to watch clipboard items: $e');
    }
  }

  @override
  Future<void> createTag({required Map<String, dynamic> data}) async {
    try {
      await remoteDataSource.createTag(data: data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create tag: $e');
    }
  }

  @override
  Future<void> deleteTag({required dynamic value}) {
    try {
      return remoteDataSource.deleteTag(column: 'id', value: value);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete tag: $e');
    }
  }

  @override
  Future<ClipboardHistories> fetchClipboardHistory({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final history = await remoteDataSource.fetchClipboardHistory(
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(
        history.map((item) => item.toEntity()),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch clipboard history: $e');
    }
  }

  @override
  Future<Tags> fetchTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final tags = await remoteDataSource.fetchTags(
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(
        tags.map((item) => item.toEntity()),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch tags: $e');
    }
  }

  @override
  Future<ClipboardItemTags> fetchClipboardItemTags({
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final tags = await remoteDataSource.fetchClipboardItemTags(
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

      return List.from(
        tags.map((item) => item.toEntity()),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch clipboard item tags: $e');
    }
  }
}

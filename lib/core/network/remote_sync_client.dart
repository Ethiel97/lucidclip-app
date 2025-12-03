// lib/core/network/remote_sync_client.dart
abstract class RemoteSyncClient {
  Future<void> upsert<T>({
    required String table,
    required Map<String, dynamic> data,
  });

  Future<void> upsertBatch<T>({
    required String table,
    required List<Map<String, dynamic>> data,
  });

  Future<List<Map<String, dynamic>>> fetch({
    required String table,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
  });

  Stream<List<Map<String, dynamic>>> watch({
    required String table,
    Map<String, dynamic>? filters,
  });

  Future<void> delete({
    required String table,
    required String column,
    required dynamic value,
  });
}

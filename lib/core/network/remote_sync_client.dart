// lib/core/network/remote_sync_client.dart
abstract class RemoteSyncClient {
  Future<void> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
  });

  Future<void> upsertBatch({
    required String table,
    required List<Map<String, dynamic>> data,
    String? onConflict,
  });

  Future<List<Map<String, dynamic>>> fetch({
    required String table,
    Map<String, dynamic>? filters,
    int? limit,
    String? orderBy,
    String? selectOptions,
  });

  //update
  Future<void> update({
    required String table,
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  });

  Stream<List<T>> watch<T>({
    required String table,
    Map<String, dynamic>? filters,
    String? primaryKey,
  });

  Future<void> delete({
    required String table,
    required String column,
    required dynamic value,
  });
}

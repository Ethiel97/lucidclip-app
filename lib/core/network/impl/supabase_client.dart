import 'dart:async';

import 'package:lucid_clip/core/network/remote_sync_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient implements RemoteSyncClient {
  SupabaseClient();

  final supabase = Supabase.instance.client;

  @override
  Future<void> delete({
    required String table,
    required String column,
    required dynamic value,
  }) async {
    await supabase.from(table).delete().eq(column, value as Object);
  }

  @override
  Future<List<Map<String, dynamic>>> fetch({
    required String table,
    Map<String, dynamic>? filters,
    String? selectOptions,
    String? orderBy,
    int? limit,
  }) async {
    final query = supabase.from(table).select(selectOptions ?? '*');

    if (filters != null) {
      filters.forEach((key, value) {
        query.eq(key, value as Object);
      });
    }

    if (orderBy != null) {
      unawaited(query.order(orderBy));
    }

    if (limit != null) {
      unawaited(query.limit(limit));
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response as List);
  }

  @override
  Future<void> upsert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await supabase.from(table).upsert(data);
  }

  @override
  Future<void> upsertBatch({
    required String table,
    required List<Map<String, dynamic>> data,
  }) async {
    await supabase.from(table).upsert(data);
  }

  @override
  Stream<List<T>> watch<T>({
    required String table,
    Map<String, dynamic>? filters,
  }) {
    final stream = supabase.from(table).stream(primaryKey: ['id']);

    if (filters != null) {
      filters.forEach((key, value) {
        stream.eq(key, value as Object);
      });
    }

    return stream.map((event) {
      return List<T>.from(event as List);
    });
  }

  @override
  Future<void> update({
    required String table,
    required String column,
    required dynamic value,
    required Map<String, dynamic> data,
  }) async {
    await supabase.from(table).update(data).eq(column, value as Object);
  }
}

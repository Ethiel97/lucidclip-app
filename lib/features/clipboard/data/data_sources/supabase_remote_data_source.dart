import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

@LazySingleton(as: ClipboardRemoteDataSource)
class SupabaseRemoteDataSource implements ClipboardRemoteDataSource {
  @override
  Future<void> deleteClipboardItem({required String column, required value}) {
    // TODO: implement deleteClipboardItem
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchClipboardItems(
      {Map<String, dynamic>? filters, String? orderBy, int? limit}) {
    // TODO: implement fetchClipboardItems
    throw UnimplementedError();
  }

  @override
  Future<void> updateClipboardItem(
      {required String column,
      required value,
      required Map<String, dynamic> data}) {
    // TODO: implement updateClipboardItem
    throw UnimplementedError();
  }

  @override
  Future<void> upsertClipboardItem({required Map<String, dynamic> data}) {
    // TODO: implement upsertClipboardItem
    throw UnimplementedError();
  }

  @override
  Future<void> upsertClipboardItemsBatch(
      {required List<Map<String, dynamic>> data}) {
    // TODO: implement upsertClipboardItemsBatch
    throw UnimplementedError();
  }

  @override
  Stream<List<Map<String, dynamic>>> watchClipboardItems(
      {Map<String, dynamic>? filters}) {
    // TODO: implement watchClipboardItems
    throw UnimplementedError();
  }
}

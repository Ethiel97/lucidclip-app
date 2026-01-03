import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/network/network.dart';
import 'package:lucid_clip/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';

@LazySingleton(as: SettingsRemoteDataSource)
class SupabaseSettingsRemoteDataSource implements SettingsRemoteDataSource {
  const SupabaseSettingsRemoteDataSource({
    required RemoteSyncClient networkClient,
  }) : _networkClient = networkClient;

  static String userSettingsTable = 'user_settings';

  final RemoteSyncClient _networkClient;

  @override
  Future<UserSettingsModel?> fetchSettings(String userId) async {
    try {
      final response = await _networkClient.fetch(
        table: userSettingsTable,
        filters: {'user_id': userId},
        limit: 1,
      );

      if (response.isEmpty) return null;

      return UserSettingsModel.fromJson(
        response.first,
      );
    } catch (e, stack) {
      throw NetworkException(
        'Failed to fetch settings: $e $stack',
      );
    }
  }

  @override
  Future<void> upsertSettings(Map<String, dynamic> data) async {
    try {
      await _networkClient.upsert(
        table: userSettingsTable,
        data: data,
      );
    } catch (e, stack) {
      throw NetworkException(
        'Failed to upsert settings: $e $stack',
      );
    }
  }

  @override
  Stream<UserSettingsModel?> watchSettings(String userId) {
    try {
      final stream = _networkClient.watch(
        table: userSettingsTable,
        filters: {'user_id': userId},
      );

      return stream.map((response) {
        if (response.isEmpty) return null;
        return UserSettingsModel.fromJson(
          response.first as Map<String, dynamic>,
        );
      });
    } catch (e, stack) {
      throw NetworkException(
        'Failed to watch settings: $e $stack',
      );
    }
  }
}

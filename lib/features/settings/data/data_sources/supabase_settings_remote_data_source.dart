import 'dart:async';

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

      return UserSettingsModel.fromJson(response.first);
    } catch (e, stack) {
      throw NetworkException('Failed to fetch settings: $e $stack');
    }
  }

  @override
  Future<void> upsertSettings(Map<String, dynamic> data) async {
    try {
      await _networkClient.upsert(
        table: userSettingsTable,
        data: data,
        onConflict: 'user_id',
      );
    } catch (e, stack) {
      throw NetworkException('Failed to upsert settings: $e $stack');
    }
  }

  @override
  Future<SettingsRemoteSubscription> subscribeSettings(String userId) async {
    final rawStream = _networkClient.watch<Map<String, dynamic>>(
      table: userSettingsTable,
      primaryKey: 'user_id',
      filters: {'user_id': userId},
    );

    return _SupabaseSettingsRemoteSubscription(rawStream);
  }
}

class _SupabaseSettingsRemoteSubscription
    implements SettingsRemoteSubscription {
  _SupabaseSettingsRemoteSubscription(this._rawStream);

  final Stream<List<Map<String, dynamic>>> _rawStream;

  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  final _controller = StreamController<UserSettingsModel>.broadcast();

  bool _started = false;

  @override
  Stream<UserSettingsModel> get stream {
    if (!_started) {
      _started = true;
      _sub = _rawStream.listen((rows) {
        if (rows.isEmpty) return;

        final latest = rows.last;
        _controller.add(UserSettingsModel.fromJson(latest));
      }, onError: _controller.addError);
    }
    return _controller.stream;
  }

  @override
  Future<void> cancel() async {
    await _sub?.cancel();
    await _controller.close();
  }
}

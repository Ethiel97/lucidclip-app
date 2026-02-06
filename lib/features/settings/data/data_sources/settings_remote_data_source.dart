import 'package:lucid_clip/features/settings/data/models/models.dart';

abstract class SettingsRemoteSubscription {
  Stream<UserSettingsModel> get stream;

  Future<void> cancel();
}

abstract class SettingsRemoteDataSource {
  Future<UserSettingsModel?> fetchSettings(String userId);

  Future<void> upsertSettings(Map<String, dynamic> data);

  Future<SettingsRemoteSubscription> subscribeSettings(String userId);
}

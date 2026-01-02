import 'package:lucid_clip/features/settings/data/models/models.dart';

abstract class SettingsRemoteDataSource {
  Future<UserSettingsModel?> fetchSettings(String userId);
  Future<void> upsertSettings(Map<String, dynamic> data);
  Stream<UserSettingsModel?> watchSettings(String userId);
}

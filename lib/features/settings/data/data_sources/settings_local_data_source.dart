import 'package:lucid_clip/features/settings/data/models/models.dart';

abstract class SettingsLocalDataSource {
  Future<UserSettingsModel?> getSettings(String userId);
  Future<void> upsertSettings(UserSettingsModel settings);
  Future<void> deleteSettings(String userId);
  Stream<UserSettingsModel?> watchSettings(String userId);
}

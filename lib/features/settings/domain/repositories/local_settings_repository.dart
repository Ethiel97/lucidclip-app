import 'package:lucid_clip/features/settings/domain/entities/entities.dart';

abstract class LocalSettingsRepository {
  Future<UserSettings?> getSettings(String userId);

  Future<void> upsertSettings(UserSettings settings);

  Future<void> deleteSettings(String userId);

  Stream<UserSettings?> watchSettings(String userId);
}

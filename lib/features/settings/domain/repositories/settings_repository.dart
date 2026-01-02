import 'package:lucid_clip/features/settings/domain/entities/entities.dart';

abstract class SettingsRepository {
  Future<UserSettings?> getSettings(String userId);
  Future<void> updateSettings(UserSettings settings);
  Stream<UserSettings?> watchSettings(String userId);
}

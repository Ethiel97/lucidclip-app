import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

/// Adapter/facade for components that still need LocalSettingsRepository
/// Delegates to the unified SettingsRepository
@LazySingleton(as: LocalSettingsRepository)
class LocalSettingsRepositoryImpl implements LocalSettingsRepository {
  LocalSettingsRepositoryImpl({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  @override
  Future<UserSettings?> getSettings(String userId) async {
    return settingsRepository.load(userId);
  }

  @override
  Future<void> upsertSettings(UserSettings settings) async {
    await settingsRepository.update(settings);
  }

  @override
  Future<void> deleteSettings(String userId) async {
    await settingsRepository.clearLocal(userId);
  }

  @override
  Stream<UserSettings?> watchSettings(String userId) {
    return settingsRepository.watchLocal(userId);
  }
}

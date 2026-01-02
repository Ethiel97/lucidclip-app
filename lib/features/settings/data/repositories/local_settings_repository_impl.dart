import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/settings/data/data_sources/data_sources.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

@LazySingleton(as: LocalSettingsRepository)
class LocalSettingsRepositoryImpl implements LocalSettingsRepository {
  LocalSettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<UserSettings?> getSettings(String userId) async {
    try {
      final model = await _localDataSource.getSettings(userId);
      return model?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }

  @override
  Future<void> upsertSettings(UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      await _localDataSource.upsertSettings(model);
    } catch (e) {
      throw CacheException('Failed to upsert settings: $e');
    }
  }

  @override
  Future<void> deleteSettings(String userId) async {
    try {
      await _localDataSource.deleteSettings(userId);
    } catch (e) {
      throw CacheException('Failed to delete settings: $e');
    }
  }

  @override
  Stream<UserSettings?> watchSettings(String userId) {
    try {
      return _localDataSource.watchSettings(userId).map((model) {
        return model?.toEntity();
      });
    } catch (e) {
      throw CacheException('Failed to watch settings: $e');
    }
  }
}

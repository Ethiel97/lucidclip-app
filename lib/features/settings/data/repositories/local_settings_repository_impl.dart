import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/features/settings/data/data.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

@LazySingleton(as: LocalSettingsRepository)
class LocalSettingsRepositoryImpl implements LocalSettingsRepository {
  LocalSettingsRepositoryImpl({
    required this.iconService,
    required this.localDataSource,
  });

  final SettingsLocalDataSource localDataSource;
  final SourceAppIconService iconService;

  @override
  Future<UserSettings?> getSettings(String userId) async {
    try {
      final model = await localDataSource.getSettings(userId);
      return model?.toEntity();
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }

  @override
  Future<void> upsertSettings(UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      await localDataSource.upsertSettings(model);
    } catch (e) {
      throw CacheException('Failed to upsert settings: $e');
    }
  }

  @override
  Future<void> deleteSettings(String userId) async {
    try {
      await localDataSource.deleteSettings(userId);
    } catch (e) {
      throw CacheException('Failed to delete settings: $e');
    }
  }

  @override
  Stream<UserSettings?> watchSettings(String userId) {
    try {
      return localDataSource.watchSettings(userId).distinct().asyncMap((
        model,
      ) async {
        if (model == null) return null;

        final entity = model.toEntity();

        try {
          final excluded = entity.excludedApps;
          if (excluded.isEmpty) return entity;

          final updatedExcludedApps = <SourceApp>[];
          for (final app in excluded) {
            try {
              final icon = await iconService.getIcon(app.bundleId);
              updatedExcludedApps.add(app.copyWith(icon: icon ?? app.icon));
            } catch (_) {
              updatedExcludedApps.add(app);
            }
          }

          return entity.copyWith(excludedApps: updatedExcludedApps);
        } catch (_) {
          return entity;
        }
      });
    } catch (e) {
      throw CacheException('Failed to watch settings: $e');
    }
  }
}

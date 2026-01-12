import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/settings/data/data_sources/data_sources.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.remoteDataSource});

  final SettingsRemoteDataSource remoteDataSource;

  @override
  Future<UserSettings?> getSettings(String userId) async {
    try {
      final model = await remoteDataSource.fetchSettings(userId);
      return model?.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get settings: $e');
    }
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    try {
      final model = UserSettingsModel.fromEntity(settings);
      await remoteDataSource.upsertSettings(model.toJson());
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update settings: $e');
    }
  }

  @override
  Stream<UserSettings?> watchSettings(String userId) {
    try {
      return remoteDataSource.watchSettings(userId).distinct().map((model) {
        return model?.toEntity();
      });
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to watch settings: $e');
    }
  }
}

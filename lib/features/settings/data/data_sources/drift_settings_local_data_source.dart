import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:lucid_clip/features/settings/data/db/settings_database.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';

@LazySingleton(as: SettingsLocalDataSource)
class DriftSettingsLocalDataSource implements SettingsLocalDataSource {
  DriftSettingsLocalDataSource(this._db);

  final SettingsDatabase _db;

  @override
  Future<UserSettingsModel?> getSettings(String userId) async {
    final entry = await _db.getSettingsByUserId(userId);
    return entry != null ? _db.entryToModel(entry) : null;
  }

  @override
  Future<void> upsertSettings(UserSettingsModel settings) async {
    final companion = _db.modelToCompanion(settings);
    await _db.upsertSettings(companion);
  }

  @override
  Future<void> deleteSettings(String userId) async {
    await _db.deleteSettingsByUserId(userId);
  }

  @override
  Stream<UserSettingsModel?> watchSettings(String userId) {
    return _db.watchSettingsByUserId(userId).map((entry) {
      return entry != null ? _db.entryToModel(entry) : null;
    });
  }
}

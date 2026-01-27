import 'dart:developer';

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
    try {
      await _db.transaction(() async {
        final companion = _db.modelToCompanion(settings);
        await _db.upsertSettings(companion);
      });
    } catch (e, stackTrace) {
      log(
        'Error upserting settings: $e',
        name: 'DriftSettingsLocalDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteSettings(String userId) async {
    try {
      await _db.transaction(() async {
        await _db.deleteSettingsByUserId(userId);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserSettingsModel?> watchSettings(String userId) {
    return _db
        .watchSettingsByUserId(userId)
        .distinct((previous, next) => previous?.userId == next?.userId)
        .map((entry) {
          return entry != null ? _db.entryToModel(entry) : null;
        });
  }
}

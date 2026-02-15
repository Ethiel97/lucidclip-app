import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/features/settings/data/data.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'settings_database.g.dart';

const settingsDbName = 'settings_db.sqlite';

@DriftDatabase(tables: [UserSettingsEntries])
class SettingsDatabase extends _$SettingsDatabase {
  SettingsDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() => LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dbFile = File(p.join(dir.path, settingsDbName));

    if (!dbFile.parent.existsSync()) {
      await dbFile.parent.create(recursive: true);
    }
    return NativeDatabase.createInBackground(
      dbFile,
      setup: (db) {
        db
          ..execute('PRAGMA journal_mode=WAL;')
          ..execute('PRAGMA synchronous=NORMAL;');
      },
    );
  });

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  // Upsert settings
  Future<void> upsertSettings(UserSettingsEntriesCompanion companion) =>
      into(userSettingsEntries).insertOnConflictUpdate(companion);

  // Get settings by userId
  Future<UserSettingsEntry?> getSettingsByUserId(String userId) => (select(
    userSettingsEntries,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  // Watch settings by userId
  Stream<UserSettingsEntry?> watchSettingsByUserId(String userId) => (select(
    userSettingsEntries,
  )..where((t) => t.userId.equals(userId))).watchSingleOrNull();

  // Delete settings by userId
  Future<void> deleteSettingsByUserId(String userId) async {
    await (delete(
      userSettingsEntries,
    )..where((t) => t.userId.equals(userId))).go();
  }

  // Mapping helpers: entry <-> model
  UserSettingsModel entryToModel(UserSettingsEntry e) {
    final shortcuts = e.shortcuts.isEmpty
        ? <String, String>{}
        : (jsonDecode(e.shortcuts) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value.toString()),
          );

    final excludedApps = e.excludedApps.isEmpty
        ? <SourceAppModel>[]
        : (jsonDecode(e.excludedApps) as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(SourceAppModel.fromJson)
              .toList();

    return UserSettingsModel(
      userId: e.userId,
      theme: e.theme,
      shortcuts: shortcuts,
      autoSync: e.autoSync,
      syncIntervalMinutes: e.syncIntervalMinutes,
      maxHistoryItems: e.maxHistoryItems,
      retentionDays: e.retentionDays,
      showSourceApp: e.showSourceApp,
      previewImages: e.previewImages,
      previewLinks: e.previewLinks,
      incognitoMode: e.incognitoMode,
      excludedApps: excludedApps,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      incognitoSessionDurationMinutes: e.incognitoSessionDurationMinutes,
      incognitoSessionEndTime: e.incognitoSessionEndTime,
    );
  }

  UserSettingsEntriesCompanion modelToCompanion(UserSettingsModel m) {
    final excludedApps = m.excludedApps.isEmpty
        ? '[]'
        : jsonEncode(m.excludedApps.map((e) => e.toJson()).toList());
    return UserSettingsEntriesCompanion(
      userId: Value(m.userId),
      theme: Value(m.theme),
      shortcuts: Value(m.shortcuts.isNotEmpty ? jsonEncode(m.shortcuts) : '{}'),
      autoSync: Value(m.autoSync),
      syncIntervalMinutes: Value(m.syncIntervalMinutes),
      maxHistoryItems: Value(m.maxHistoryItems),
      retentionDays: Value(m.retentionDays),
      showSourceApp: Value(m.showSourceApp),
      previewImages: Value(m.previewImages),
      previewLinks: Value(m.previewLinks),
      incognitoMode: Value(m.incognitoMode),
      excludedApps: Value(excludedApps),
      createdAt: Value(m.createdAt),
      updatedAt: Value(m.updatedAt.toUtc()),
      incognitoSessionDurationMinutes: Value(m.incognitoSessionDurationMinutes),
      incognitoSessionEndTime: Value(m.incognitoSessionEndTime),
    );
  }
}

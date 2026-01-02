import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';
import 'package:lucid_clip/features/settings/data/db/settings_tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'settings_database.g.dart';

@DriftDatabase(tables: [UserSettingsEntries])
class SettingsDatabase extends _$SettingsDatabase {
  SettingsDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dir.path, 'settings_db.sqlite'));
      if (!dbFile.parent.existsSync()) {
        await dbFile.parent.create(recursive: true);
      }
      return NativeDatabase(dbFile);
    });
  }

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
  Future<UserSettingsEntry?> getSettingsByUserId(String userId) =>
      (select(userSettingsEntries)..where((t) => t.userId.equals(userId)))
          .getSingleOrNull();

  // Watch settings by userId
  Stream<UserSettingsEntry?> watchSettingsByUserId(String userId) =>
      (select(userSettingsEntries)..where((t) => t.userId.equals(userId)))
          .watchSingleOrNull();

  // Delete settings by userId
  Future<void> deleteSettingsByUserId(String userId) async {
    await (delete(userSettingsEntries)..where((t) => t.userId.equals(userId)))
        .go();
  }

  // Mapping helpers: entry <-> model
  UserSettingsModel entryToModel(UserSettingsEntry e) {
    final shortcuts = e.shortcutsJson.isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(
            jsonDecode(e.shortcutsJson) as Map<String, dynamic>,
          );

    return UserSettingsModel(
      userId: e.userId,
      theme: e.theme,
      shortcuts: shortcuts,
      autoSync: e.autoSync,
      syncIntervalMinutes: e.syncIntervalMinutes,
      maxHistoryItems: e.maxHistoryItems,
      retentionDays: e.retentionDays,
      pinOnTop: e.pinOnTop,
      showSourceApp: e.showSourceApp,
      previewImages: e.previewImages,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  UserSettingsEntriesCompanion modelToCompanion(UserSettingsModel m) {
    return UserSettingsEntriesCompanion(
      userId: Value(m.userId),
      theme: Value(m.theme),
      shortcutsJson: Value(
        m.shortcuts.isNotEmpty ? jsonEncode(m.shortcuts) : '{}',
      ),
      autoSync: Value(m.autoSync),
      syncIntervalMinutes: Value(m.syncIntervalMinutes),
      maxHistoryItems: Value(m.maxHistoryItems),
      retentionDays: Value(m.retentionDays),
      pinOnTop: Value(m.pinOnTop),
      showSourceApp: Value(m.showSourceApp),
      previewImages: Value(m.previewImages),
      createdAt: Value(m.createdAt),
      updatedAt: Value(m.updatedAt),
    );
  }
}

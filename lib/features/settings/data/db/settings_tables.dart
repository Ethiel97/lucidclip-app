import 'package:drift/drift.dart';

class UserSettingsEntries extends Table {
  TextColumn get userId => text().named('user_id')();

  TextColumn get theme => text().withDefault(const Constant('dark'))();

  TextColumn get shortcutsJson =>
      text().named('shortcuts_json').withDefault(const Constant('{}'))();

  BoolColumn get autoSync =>
      boolean().named('auto_sync').withDefault(const Constant(false))();

  BoolColumn get incognitoMode =>
      boolean().named('incognito_mode').withDefault(const Constant(false))();

  IntColumn get syncIntervalMinutes => integer()
      .named('sync_interval_minutes')
      .withDefault(const Constant(60))();

  IntColumn get maxHistoryItems =>
      integer().named('max_history_items').withDefault(const Constant(50))();

  IntColumn get retentionDays =>
      integer().named('retention_days').withDefault(const Constant(5))();

  BoolColumn get showSourceApp =>
      boolean().named('show_source_app').withDefault(const Constant(true))();

  BoolColumn get previewImages =>
      boolean().named('preview_images').withDefault(const Constant(true))();

  BoolColumn get previewLinks =>
      boolean().named('preview_links').withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {userId};
}

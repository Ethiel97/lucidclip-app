import 'package:drift/drift.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

class UserSettingsEntries extends Table {
  TextColumn get userId => text().named('user_id')();

  TextColumn get theme => text().withDefault(const Constant('dark'))();

  TextColumn get shortcuts =>
      text().named('shortcuts').withDefault(const Constant('{}'))();

  BoolColumn get autoSync =>
      boolean().named('auto_sync').withDefault(const Constant(false))();

  TextColumn get excludedApps =>
      text().named('excluded_apps').withDefault(const Constant('[]'))();

  BoolColumn get incognitoMode =>
      boolean().named('incognito_mode').withDefault(const Constant(false))();

  IntColumn get syncIntervalMinutes => integer()
      .named('sync_interval_minutes')
      .withDefault(const Constant(defaultSyncIntervalMinutes))();

  IntColumn get maxHistoryItems => integer()
      .named('max_history_items')
      .withDefault(const Constant(defaultMaxHistoryItems))();

  IntColumn get retentionDays => integer()
      .named('retention_days')
      .withDefault(const Constant(defaultRetentionDays))();

  BoolColumn get showSourceApp =>
      boolean().named('show_source_app').withDefault(const Constant(true))();

  BoolColumn get previewImages =>
      boolean().named('preview_images').withDefault(const Constant(true))();

  BoolColumn get previewLinks =>
      boolean().named('preview_links').withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  IntColumn get incognitoSessionDurationMinutes =>
      integer().named('incognito_session_duration_minutes').nullable()();

  DateTimeColumn get incognitoSessionEndTime =>
      dateTime().named('incognito_session_end_time').nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

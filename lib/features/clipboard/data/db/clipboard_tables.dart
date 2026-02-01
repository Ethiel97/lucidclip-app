// dart
import 'package:drift/drift.dart';

class ClipboardItemEntries extends Table {
  TextColumn get id => text()();

  TextColumn get content => text()();

  TextColumn get contentHash => text().named('content_hash')();

  TextColumn get userId => text().named('user_id')();

  IntColumn get usageCount =>
      integer().named('usage_count').withDefault(const Constant(0))();

  TextColumn get type => text().named('type')();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();

  IntColumn get version =>
      integer().named('version').withDefault(const Constant(0))();

  //0 clean, 1 dirty, 2 pending 3 conflict 4 error
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('clean'))();

  TextColumn get lastModifiedByDeviceId =>
      text().named('last_modified_by_device_id').nullable()();

  DateTimeColumn get lastUsedAt =>
      dateTime().named('last_used_at').nullable()();

  TextColumn get htmlContent => text().named('html_content').nullable()();

  TextColumn get imageBytes => text().named('image_bytes').nullable()();

  TextColumn get filePath => text().named('file_path').nullable()();

  BoolColumn get isPinned =>
      boolean().named('is_pinned').withDefault(const Constant(false))();

  BoolColumn get isSnippet =>
      boolean().named('is_snippet').withDefault(const Constant(false))();

  TextColumn get metadataJson => text().named('metadata_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ClipboardOutboxEntries extends Table {
  TextColumn get operationId => text().named('operation_id')();

  TextColumn get entityId => text().named('entity_id')();

  TextColumn get userId => text().named('user_id')();

  TextColumn get operationType => text()();

  TextColumn get payload => text().named('payload').nullable()();

  TextColumn get deviceId => text().named('device_id')();

  TextColumn get status =>
      text().named('status').withDefault(const Constant('pending'))();

  DateTimeColumn get sentAt => dateTime().named('sent_at').nullable()();

  IntColumn get retryCount =>
      integer().named('retry_count').withDefault(const Constant(0))();

  TextColumn get lastError => text().named('last_error').nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {operationId};
}

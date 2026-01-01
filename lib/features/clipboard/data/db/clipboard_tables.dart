// dart
import 'package:drift/drift.dart';

class ClipboardItemEntries extends Table {
  TextColumn get id => text()();

  TextColumn get content => text()();

  TextColumn get contentHash => text().named('content_hash')();

  TextColumn get userId => text().named('user_id')();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  TextColumn get htmlContent => text().named('html_content').nullable()();

  TextColumn get imageBytes => text().named('image_bytes').nullable()();

  TextColumn get filePaths =>
      text().named('file_paths').withDefault(const Constant('[]'))();

  BoolColumn get isPinned =>
      boolean().named('is_pinned').withDefault(const Constant(false))();

  BoolColumn get isSnippet =>
      boolean().named('is_snippet').withDefault(const Constant(false))();

  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();

  TextColumn get metadataJson => text().named('metadata_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ClipboardHistoryEntries extends Table {
  TextColumn get id => text()();

  TextColumn get clipboardItemId => text().named('clipboard_item_id')();

  TextColumn get userId => text().named('user_id')();

  TextColumn get action => text()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

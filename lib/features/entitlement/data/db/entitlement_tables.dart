import 'package:drift/drift.dart';

class EntitlementEntries extends Table {
  TextColumn get id => text().named('id')();

  TextColumn get userId => text().named('user_id')();

  BoolColumn get pro => boolean().named('pro')();

  TextColumn get source => text().named('source')();

  TextColumn get status => text()();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get validUntil => dateTime().nullable().named('valid_until')();

  @override
  Set<Column> get primaryKey => {userId, id};
}

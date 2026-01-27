import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'entitlement_database.g.dart';

@DriftDatabase(tables: [EntitlementEntries])
class EntitlementDatabase extends _$EntitlementDatabase {
  EntitlementDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final dbFile = File(p.join(dir.path, 'entitlement_db.sqlite'));

      /* if (dbFile.existsSync()) {
        if (!AppConstants.isProd) {
          await dbFile.delete();
        }
      }*/

      if (!dbFile.parent.existsSync()) {
        await dbFile.parent.create(recursive: true);
      }
      return NativeDatabase(dbFile);
    });
  }

  @override
  int get schemaVersion => 1;

  EntitlementModel entryToModel(EntitlementEntry entry) {
    return EntitlementModel(
      id: entry.id,
      pro: entry.pro,
      source: entry.source,
      status: EntitlementStatusModel.values.firstWhere(
        (e) => e.name == entry.status,
        orElse: () => EntitlementStatusModel.inactive,
      ),
      updatedAt: entry.updatedAt,
      userId: entry.userId,
      validUntil: entry.validUntil,
    );
  }

  EntitlementEntriesCompanion modelToCompanion(EntitlementModel model) {
    return EntitlementEntriesCompanion(
      id: Value(model.id),
      pro: Value(model.pro),
      source: Value(model.source),
      status: Value(model.status.name),
      updatedAt: Value(model.updatedAt),
      userId: Value(model.userId),
      validUntil: Value(model.validUntil),
    );
  }

  //delete entitlement by userId
  Future<void> deleteEntitlementByUserId(String userId) {
    return (delete(
      entitlementEntries,
    )..where((t) => t.userId.equals(userId))).go();
  }

  Future<EntitlementEntry?> getEntitlementByUserId(String userId) => (select(
    entitlementEntries,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<void> upsertEntitlement(EntitlementEntriesCompanion companion) =>
      into(entitlementEntries).insertOnConflictUpdate(companion);

  Stream<EntitlementEntry?> watchEntitlementByUserId(String userId) => (select(
    entitlementEntries,
  )..where((t) => t.userId.equals(userId))).watchSingleOrNull();
}

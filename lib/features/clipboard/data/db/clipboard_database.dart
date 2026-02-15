import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart'; // pour ClipboardItemModel

part 'clipboard_database.g.dart';

@DriftDatabase(tables: [ClipboardItemEntries, ClipboardOutboxEntries])
class ClipboardDatabase extends _$ClipboardDatabase {
  ClipboardDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  static DriftIsolate? _isolate;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      // Create an isolate for database operations
      _isolate ??= await _createDriftIsolate();
      return _isolate!.connect();
    });
  }

  static Future<DriftIsolate> _createDriftIsolate() async {
    // Get the database file path on the main isolate
    final dir = await getApplicationSupportDirectory();
    final dbPath = p.join(dir.path, 'clipboard_db.sqlite');

    // Ensure parent directory exists
    final dbFile = File(dbPath);
    if (!dbFile.parent.existsSync()) {
      await dbFile.parent.create(recursive: true);
    }

    // Spawn the isolate with the database path
    return await DriftIsolate.spawn(() {
      return DatabaseConnection(
        NativeDatabase(File(dbPath)),
      );
    });
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1 && to == 2) {
        // Add clipboardOutboxEntries table
        await m.createTable(clipboardOutboxEntries);
      }
    },
  );

  Future<void> upsertItem(ClipboardItemEntriesCompanion companion) =>
      into(clipboardItemEntries).insertOnConflictUpdate(companion);

  Future<void> upsertItemsBatch(List<ClipboardItemEntriesCompanion> comps) =>
      batch((b) => b.insertAllOnConflictUpdate(clipboardItemEntries, comps));

  Future<ClipboardItemEntry?> getById(String id) => (select(
    clipboardItemEntries,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ClipboardItemEntry?> getByContentHash(String contentHash) => (select(
    clipboardItemEntries,
  )..where((t) => t.contentHash.equals(contentHash))).getSingleOrNull();

  Future<List<ClipboardItemEntry>> getAllEntries() =>
      (select(clipboardItemEntries)
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..where((t) => t.deletedAt.isNull()))
          .get();

  Stream<List<ClipboardItemEntry>> watchAllEntries({required int limit}) =>
      (select(clipboardItemEntries)
            ..limit(limit)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  Future<List<ClipboardItemEntry>> getUnsyncedEntries() => (select(
    clipboardItemEntries,
  )..where((t) => t.syncStatus.equals(SyncStatusModel.pending.name))).get();

  //update sync status
  Future<void> updateSyncStatus(String id, {required bool isSynced}) async {
    final status = isSynced ? SyncStatusModel.clean : SyncStatusModel.pending;
    await (update(clipboardItemEntries)..where((t) => t.id.equals(id))).write(
      ClipboardItemEntriesCompanion(syncStatus: Value(status.name)),
    );
  }

  Future<void> deleteById(String id) async {
    // await (delete(clipboardItemEntries)..where((t) => t.id.equals(id))).go();
    final now = DateTime.now().toUtc();
    await (update(clipboardItemEntries)..where((t) => t.id.equals(id))).write(
      ClipboardItemEntriesCompanion(deletedAt: Value(now)),
    );
  }

  Future<void> deleteByContentHash(String contentHash) async {
    // await (delete(clipboardItemEntries)..where((t)
    // => t.contentHash.equals(contentHash))).go();
    final now = DateTime.now().toUtc();
    await (update(clipboardItemEntries)
          ..where((t) => t.contentHash.equals(contentHash)))
        .write(ClipboardItemEntriesCompanion(deletedAt: Value(now)));
  }

  Future<void> clearAll() => delete(clipboardItemEntries).go();

  Future<Set<String>> getAllContentHashes() async {
    final table = clipboardItemEntries;
    final query = selectOnly(table)
      ..addColumns([table.contentHash])
      ..where(table.deletedAt.isNull());
    final rows = await query.get();

    return rows
        .map((row) => row.read<String>(table.contentHash))
        .whereType<String>()
        .toSet();
  }

  Future<int> getCountNonDeleted() async {
    final query = selectOnly(clipboardItemEntries)
      ..addColumns([clipboardItemEntries.id.count()])
      ..where(clipboardItemEntries.deletedAt.isNull());
    final result = await query.getSingleOrNull();
    return result?.read(clipboardItemEntries.id.count()) ?? 0;
  }

  Future<List<ClipboardItemEntry>> getPotentiallyExpiredItems({
    required DateTime cutoffDate,
  }) =>
      (select(clipboardItemEntries)
            ..where(
              (t) =>
                  t.deletedAt.isNull() &
                  t.isPinned.equals(false) &
                  t.isSnippet.equals(false) &
                  t.createdAt.isSmallerThanValue(cutoffDate),
            )
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  // Mapping helpers : entry <-> model

  ClipboardItemModel entryToModel(ClipboardItemEntry e) {
    final type = ClipboardItemTypeModel.values.firstWhere(
      (v) => v.name == e.type,
      orElse: () => ClipboardItemTypeModel.unknown,
    );

    final syncStatus = SyncStatusModel.values.firstWhere(
      (v) => v.name == e.syncStatus,
      orElse: () => SyncStatusModel.unknown,
    );

    final metadata = e.metadataJson == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(
            jsonDecode(e.metadataJson!) as Map<String, dynamic>,
          );

    final imageBytes = (e.imageBytes?.isEmpty ?? true)
        ? <int>[]
        : base64Decode(e.imageBytes!);

    return ClipboardItemModel(
      content: e.content,
      contentHash: e.contentHash,
      createdAt: e.createdAt,
      deletedAt: e.deletedAt,
      filePath: e.filePath,
      htmlContent: e.htmlContent,
      id: e.id,
      imageBytes: imageBytes,
      isPinned: e.isPinned,
      isSnippet: e.isSnippet,
      lastUsedAt: e.lastUsedAt,
      metadata: metadata,
      syncStatus: syncStatus,
      type: type,
      updatedAt: e.updatedAt,
      usageCount: e.usageCount,
      userId: e.userId,
      version: e.version,
    );
  }

  ClipboardItemEntriesCompanion modelToCompanion(ClipboardItemModel m) {
    return ClipboardItemEntriesCompanion(
      id: Value(m.id),
      content: Value(m.content),
      contentHash: Value(m.contentHash),
      createdAt: Value(m.createdAt),
      deletedAt: Value(m.deletedAt),
      filePath: Value(m.filePath),
      isPinned: Value(m.isPinned),
      isSnippet: Value(m.isSnippet),
      htmlContent: Value(m.htmlContent),
      imageBytes: Value(
        (m.imageBytes?.isNotEmpty ?? false)
            ? base64Encode(m.imageBytes!)
            : null,
      ),
      lastUsedAt: Value(m.lastUsedAt),
      metadataJson: Value(
        m.metadata.isNotEmpty ? jsonEncode(m.metadata) : null,
      ),
      syncStatus: Value(m.syncStatus.name),
      type: Value(m.type.name),
      updatedAt: Value(m.updatedAt),
      usageCount: Value(m.usageCount),
      userId: Value(m.userId),
      version: Value(m.version),
    );
  }

  // ---------------------------
  // Outbox methods (Sync Engine)
  // ---------------------------

  Future<void> upsertOutbox(ClipboardOutboxEntriesCompanion companion) =>
      into(clipboardOutboxEntries).insertOnConflictUpdate(companion);

  Future<void> upsertOutboxBatch(List<ClipboardOutboxEntriesCompanion> comps) =>
      batch((b) => b.insertAllOnConflictUpdate(clipboardOutboxEntries, comps));

  Future<ClipboardOutboxEntry?> getOutboxById(String opId) => (select(
    clipboardOutboxEntries,
  )..where((t) => t.operationId.equals(opId))).getSingleOrNull();

  Future<List<ClipboardOutboxEntry>> getOutboxesByEntityId(String entityId) =>
      (select(clipboardOutboxEntries)
            ..where((t) => t.entityId.equals(entityId))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  Future<List<ClipboardOutboxEntry>> getAllOutboxes({int? limit}) {
    final q = select(clipboardOutboxEntries)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) q.limit(limit);
    return q.get();
  }

  Future<List<ClipboardOutboxEntry>> getPendingOutboxes({int? limit}) {
    final q = select(clipboardOutboxEntries)
      ..where((t) => t.sentAt.isNull()) // simplest invariant
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]);

    if (limit != null) q.limit(limit);
    return q.get();
  }

  Future<List<ClipboardOutboxEntry>> getOutboxesByOperationType(
    String operationType, {
    int? limit,
  }) {
    final q = select(clipboardOutboxEntries)
      ..where((t) => t.operationType.equals(operationType))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) q.limit(limit);
    return q.get();
  }

  Stream<List<ClipboardOutboxEntry>> watchOutboxes({int? limit}) {
    final q = select(clipboardOutboxEntries)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (limit != null) q.limit(limit);
    return q.watch();
  }

  /// Mark an op as sent (acknowledged by remote)
  Future<void> markOutboxSent(String opId, DateTime sentAt) async {
    await (update(clipboardOutboxEntries)
          ..where((t) => t.operationId.equals(opId)))
        .write(ClipboardOutboxEntriesCompanion(sentAt: Value(sentAt)));
  }

  /// Mark failure (and keep it pending for retry)
  Future<void> markOutboxFailed(String opId, String error) async {
    await (update(clipboardOutboxEntries)
          ..where((t) => t.operationId.equals(opId)))
        .write(ClipboardOutboxEntriesCompanion(lastError: Value(error)));
  }

  Future<void> incrementOutboxRetry(String opId) async {
    await customStatement(
      'UPDATE clipboard_outbox_entries '
      'SET retry_count = retry_count + 1 '
      'WHERE operation_id = ?',
      [opId],
    );
  }

  /// Delete outbox item by op id
  Future<void> deleteOutboxById(String opId) async {
    await (delete(
      clipboardOutboxEntries,
    )..where((t) => t.operationId.equals(opId))).go();
  }

  Future<void> deleteOutboxesByEntityId(String entityId) async {
    await (delete(
      clipboardOutboxEntries,
    )..where((t) => t.entityId.equals(entityId))).go();
  }

  Future<void> clearOutbox() => delete(clipboardOutboxEntries).go();
}

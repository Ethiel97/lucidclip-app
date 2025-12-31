import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart'; // pour ClipboardItemModel

part 'clipboard_database.g.dart';

@DriftDatabase(tables: [ClipboardItemEntries, ClipboardHistoryEntries])
class ClipboardDatabase extends _$ClipboardDatabase {
  ClipboardDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'clipboard_db.sqlite');
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
        // Add ClipboardHistoryEntries table
        await m.createTable(clipboardHistoryEntries);
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
      (select(clipboardItemEntries)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .get();

  Stream<List<ClipboardItemEntry>> watchAllEntries() =>
      (select(clipboardItemEntries)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<List<ClipboardItemEntry>> getUnsyncedEntries() => (select(
    clipboardItemEntries,
  )..where((t) => t.isSynced.equals(false))).get();

  Future<void> updateSyncStatus(String id, {bool isSynced = false}) async {
    await (update(clipboardItemEntries)..where((t) => t.id.equals(id))).write(
      ClipboardItemEntriesCompanion(isSynced: Value(isSynced)),
    );
  }

  Future<void> deleteById(String id) async {
    await (delete(clipboardItemEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteByContentHash(String contentHash) async {
    await (delete(
      clipboardItemEntries,
    )..where((t) => t.contentHash.equals(contentHash))).go();
  }

  Future<void> clearAll() => delete(clipboardItemEntries).go();

  Future<Set<String>> getAllContentHashes() async {
    final rows = await select(clipboardItemEntries).get();
    return rows.map((r) => r.contentHash).toSet();
  }

  // Mapping helpers : entry <-> model

  ClipboardItemModel entryToModel(ClipboardItemEntry e) {
    final type = ClipboardItemTypeModel.values.firstWhere(
      (v) => v.name == e.type,
      orElse: () => ClipboardItemTypeModel.unknown,
    );

    final filePaths = (e.filePaths.isEmpty)
        ? <String>[]
        : List<String>.from(jsonDecode(e.filePaths) as List);
    final metadata = e.metadataJson == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(
            jsonDecode(e.metadataJson!) as Map<String, dynamic>,
          );

    return ClipboardItemModel(
      content: e.content,
      contentHash: e.contentHash,
      createdAt: e.createdAt,
      filePaths: filePaths,
      htmlContent: e.htmlContent,
      id: e.id,
      imageUrl: e.imageUrl,
      isPinned: e.isPinned,
      isSnippet: e.isSnippet,
      isSynced: e.isSynced,
      metadata: metadata,
      type: type,
      updatedAt: e.updatedAt,
      userId: e.userId,
    );
  }

  ClipboardItemEntriesCompanion modelToCompanion(ClipboardItemModel m) {
    return ClipboardItemEntriesCompanion(
      id: Value(m.id),
      content: Value(m.content),
      contentHash: Value(m.contentHash),
      userId: Value(m.userId),
      type: Value(m.type.name),
      createdAt: Value(m.createdAt),
      updatedAt: Value(m.updatedAt),
      htmlContent: Value(m.htmlContent),
      imageUrl: Value(m.imageUrl),
      filePaths: Value(jsonEncode(m.filePaths)),
      isPinned: Value(m.isPinned),
      isSnippet: Value(m.isSnippet),
      isSynced: Value(m.isSynced),
      metadataJson: Value(
        m.metadata.isNotEmpty ? jsonEncode(m.metadata) : null,
      ),
    );
  }

  // Clipboard History methods

  Future<void> upsertHistory(ClipboardHistoryEntriesCompanion companion) =>
      into(clipboardHistoryEntries).insertOnConflictUpdate(companion);

  Future<void> upsertHistoriesBatch(
    List<ClipboardHistoryEntriesCompanion> comps,
  ) =>
      batch((b) => b.insertAllOnConflictUpdate(clipboardHistoryEntries, comps));

  Future<ClipboardHistoryEntry?> getHistoryById(String id) => (select(
    clipboardHistoryEntries,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ClipboardHistoryEntry>> getHistoriesByClipboardItemId(
    String clipboardItemId,
  ) =>
      (select(clipboardHistoryEntries)
            ..where((t) => t.clipboardItemId.equals(clipboardItemId))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  Future<List<ClipboardHistoryEntry>> getAllHistories() =>
      (select(clipboardHistoryEntries)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .get();

  Future<List<ClipboardHistoryEntry>> getHistoriesByAction(String action) =>
      (select(clipboardHistoryEntries)
            ..where((t) => t.action.equals(action))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  Stream<List<ClipboardHistoryEntry>> watchAllHistories() =>
      (select(clipboardHistoryEntries)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<void> deleteHistoryById(String id) async {
    await (delete(clipboardHistoryEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteHistoriesByClipboardItemId(String clipboardItemId) async {
    await (delete(
      clipboardHistoryEntries,
    )..where((t) => t.clipboardItemId.equals(clipboardItemId))).go();
  }

  Future<void> clearAllHistories() => delete(clipboardHistoryEntries).go();
}

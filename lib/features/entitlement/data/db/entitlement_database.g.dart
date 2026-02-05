// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_database.dart';

// ignore_for_file: type=lint
class $EntitlementEntriesTable extends EntitlementEntries
    with TableInfo<$EntitlementEntriesTable, EntitlementEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $EntitlementEntriesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proMeta = const VerificationMeta('pro');
  @override
  late final GeneratedColumn<bool> pro = GeneratedColumn<bool>(
    'pro',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pro" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    pro,
    source,
    status,
    updatedAt,
    validUntil,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'entitlement_entries';

  @override
  VerificationContext validateIntegrity(
    Insertable<EntitlementEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('pro')) {
      context.handle(
        _proMeta,
        pro.isAcceptableOrUnknown(data['pro']!, _proMeta),
      );
    } else if (isInserting) {
      context.missing(_proMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};

  @override
  EntitlementEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitlementEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      pro: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pro'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
    );
  }

  @override
  $EntitlementEntriesTable createAlias(String alias) {
    return $EntitlementEntriesTable(attachedDatabase, alias);
  }
}

class EntitlementEntry extends DataClass
    implements Insertable<EntitlementEntry> {
  final String id;
  final String userId;
  final bool pro;
  final String source;
  final String status;
  final DateTime updatedAt;
  final DateTime? validUntil;

  const EntitlementEntry({
    required this.id,
    required this.userId,
    required this.pro,
    required this.source,
    required this.status,
    required this.updatedAt,
    this.validUntil,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['pro'] = Variable<bool>(pro);
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    return map;
  }

  EntitlementEntriesCompanion toCompanion(bool nullToAbsent) {
    return EntitlementEntriesCompanion(
      id: Value(id),
      userId: Value(userId),
      pro: Value(pro),
      source: Value(source),
      status: Value(status),
      updatedAt: Value(updatedAt),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
    );
  }

  factory EntitlementEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitlementEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      pro: serializer.fromJson<bool>(json['pro']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'pro': serializer.toJson<bool>(pro),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
    };
  }

  EntitlementEntry copyWith({
    String? id,
    String? userId,
    bool? pro,
    String? source,
    String? status,
    DateTime? updatedAt,
    Value<DateTime?> validUntil = const Value.absent(),
  }) => EntitlementEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    pro: pro ?? this.pro,
    source: source ?? this.source,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
  );

  EntitlementEntry copyWithCompanion(EntitlementEntriesCompanion data) {
    return EntitlementEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      pro: data.pro.present ? data.pro.value : this.pro,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('pro: $pro, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('validUntil: $validUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, pro, source, status, updatedAt, validUntil);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitlementEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.pro == this.pro &&
          other.source == this.source &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.validUntil == this.validUntil);
}

class EntitlementEntriesCompanion extends UpdateCompanion<EntitlementEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<bool> pro;
  final Value<String> source;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> validUntil;
  final Value<int> rowid;

  const EntitlementEntriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.pro = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  EntitlementEntriesCompanion.insert({
    required String id,
    required String userId,
    required bool pro,
    required String source,
    required String status,
    required DateTime updatedAt,
    this.validUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       pro = Value(pro),
       source = Value(source),
       status = Value(status),
       updatedAt = Value(updatedAt);

  static Insertable<EntitlementEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<bool>? pro,
    Expression<String>? source,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? validUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (pro != null) 'pro': pro,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (validUntil != null) 'valid_until': validUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitlementEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<bool>? pro,
    Value<String>? source,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? validUntil,
    Value<int>? rowid,
  }) {
    return EntitlementEntriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pro: pro ?? this.pro,
      source: source ?? this.source,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      validUntil: validUntil ?? this.validUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pro.present) {
      map['pro'] = Variable<bool>(pro.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('pro: $pro, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('validUntil: $validUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$EntitlementDatabase extends GeneratedDatabase {
  _$EntitlementDatabase(QueryExecutor e) : super(e);

  $EntitlementDatabaseManager get managers => $EntitlementDatabaseManager(this);
  late final $EntitlementEntriesTable entitlementEntries =
      $EntitlementEntriesTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entitlementEntries];
}

typedef $$EntitlementEntriesTableCreateCompanionBuilder =
    EntitlementEntriesCompanion Function({
      required String id,
      required String userId,
      required bool pro,
      required String source,
      required String status,
      required DateTime updatedAt,
      Value<DateTime?> validUntil,
      Value<int> rowid,
    });
typedef $$EntitlementEntriesTableUpdateCompanionBuilder =
    EntitlementEntriesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<bool> pro,
      Value<String> source,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<DateTime?> validUntil,
      Value<int> rowid,
    });

class $$EntitlementEntriesTableFilterComposer
    extends Composer<_$EntitlementDatabase, $EntitlementEntriesTable> {
  $$EntitlementEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pro => $composableBuilder(
    column: $table.pro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitlementEntriesTableOrderingComposer
    extends Composer<_$EntitlementDatabase, $EntitlementEntriesTable> {
  $$EntitlementEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pro => $composableBuilder(
    column: $table.pro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitlementEntriesTableAnnotationComposer
    extends Composer<_$EntitlementDatabase, $EntitlementEntriesTable> {
  $$EntitlementEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get pro =>
      $composableBuilder(column: $table.pro, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );
}

class $$EntitlementEntriesTableTableManager
    extends
        RootTableManager<
          _$EntitlementDatabase,
          $EntitlementEntriesTable,
          EntitlementEntry,
          $$EntitlementEntriesTableFilterComposer,
          $$EntitlementEntriesTableOrderingComposer,
          $$EntitlementEntriesTableAnnotationComposer,
          $$EntitlementEntriesTableCreateCompanionBuilder,
          $$EntitlementEntriesTableUpdateCompanionBuilder,
          (
            EntitlementEntry,
            BaseReferences<
              _$EntitlementDatabase,
              $EntitlementEntriesTable,
              EntitlementEntry
            >,
          ),
          EntitlementEntry,
          PrefetchHooks Function()
        > {
  $$EntitlementEntriesTableTableManager(
    _$EntitlementDatabase db,
    $EntitlementEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitlementEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitlementEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitlementEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<bool> pro = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementEntriesCompanion(
                id: id,
                userId: userId,
                pro: pro,
                source: source,
                status: status,
                updatedAt: updatedAt,
                validUntil: validUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required bool pro,
                required String source,
                required String status,
                required DateTime updatedAt,
                Value<DateTime?> validUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementEntriesCompanion.insert(
                id: id,
                userId: userId,
                pro: pro,
                source: source,
                status: status,
                updatedAt: updatedAt,
                validUntil: validUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitlementEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$EntitlementDatabase,
      $EntitlementEntriesTable,
      EntitlementEntry,
      $$EntitlementEntriesTableFilterComposer,
      $$EntitlementEntriesTableOrderingComposer,
      $$EntitlementEntriesTableAnnotationComposer,
      $$EntitlementEntriesTableCreateCompanionBuilder,
      $$EntitlementEntriesTableUpdateCompanionBuilder,
      (
        EntitlementEntry,
        BaseReferences<
          _$EntitlementDatabase,
          $EntitlementEntriesTable,
          EntitlementEntry
        >,
      ),
      EntitlementEntry,
      PrefetchHooks Function()
    >;

class $EntitlementDatabaseManager {
  final _$EntitlementDatabase _db;

  $EntitlementDatabaseManager(this._db);

  $$EntitlementEntriesTableTableManager get entitlementEntries =>
      $$EntitlementEntriesTableTableManager(_db, _db.entitlementEntries);
}

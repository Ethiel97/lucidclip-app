// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_database.dart';

// ignore_for_file: type=lint
class $UserSettingsEntriesTable extends UserSettingsEntries
    with TableInfo<$UserSettingsEntriesTable, UserSettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsEntriesTable(this.attachedDatabase, [this._alias]);
  
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dark'),
  );
  
  static const VerificationMeta _shortcutsJsonMeta = const VerificationMeta('shortcutsJson');
  @override
  late final GeneratedColumn<String> shortcutsJson = GeneratedColumn<String>(
    'shortcuts_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  
  static const VerificationMeta _autoSyncMeta = const VerificationMeta('autoSync');
  @override
  late final GeneratedColumn<bool> autoSync = GeneratedColumn<bool>(
    'auto_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("auto_sync" IN (0, 1))'),
  );
  
  static const VerificationMeta _syncIntervalMinutesMeta = const VerificationMeta('syncIntervalMinutes');
  @override
  late final GeneratedColumn<int> syncIntervalMinutes = GeneratedColumn<int>(
    'sync_interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  
  static const VerificationMeta _maxHistoryItemsMeta = const VerificationMeta('maxHistoryItems');
  @override
  late final GeneratedColumn<int> maxHistoryItems = GeneratedColumn<int>(
    'max_history_items',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000),
  );
  
  static const VerificationMeta _retentionDaysMeta = const VerificationMeta('retentionDays');
  @override
  late final GeneratedColumn<int> retentionDays = GeneratedColumn<int>(
    'retention_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  
  static const VerificationMeta _pinOnTopMeta = const VerificationMeta('pinOnTop');
  @override
  late final GeneratedColumn<bool> pinOnTop = GeneratedColumn<bool>(
    'pin_on_top',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("pin_on_top" IN (0, 1))'),
  );
  
  static const VerificationMeta _showSourceAppMeta = const VerificationMeta('showSourceApp');
  @override
  late final GeneratedColumn<bool> showSourceApp = GeneratedColumn<bool>(
    'show_source_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("show_source_app" IN (0, 1))'),
  );
  
  static const VerificationMeta _previewImagesMeta = const VerificationMeta('previewImages');
  @override
  late final GeneratedColumn<bool> previewImages = GeneratedColumn<bool>(
    'preview_images',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("preview_images" IN (0, 1))'),
  );
  
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        theme,
        shortcutsJson,
        autoSync,
        syncIntervalMinutes,
        maxHistoryItems,
        retentionDays,
        pinOnTop,
        showSourceApp,
        previewImages,
        createdAt,
        updatedAt,
      ];
      
  @override
  String get aliasedName => _alias ?? actualTableName;
  
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_entries';
  
  @override
  VerificationContext validateIntegrity(Insertable<UserSettingsEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('shortcuts_json')) {
      context.handle(
          _shortcutsJsonMeta,
          shortcutsJson.isAcceptableOrUnknown(
              data['shortcuts_json']!, _shortcutsJsonMeta));
    }
    if (data.containsKey('auto_sync')) {
      context.handle(_autoSyncMeta,
          autoSync.isAcceptableOrUnknown(data['auto_sync']!, _autoSyncMeta));
    }
    if (data.containsKey('sync_interval_minutes')) {
      context.handle(
          _syncIntervalMinutesMeta,
          syncIntervalMinutes.isAcceptableOrUnknown(
              data['sync_interval_minutes']!, _syncIntervalMinutesMeta));
    }
    if (data.containsKey('max_history_items')) {
      context.handle(
          _maxHistoryItemsMeta,
          maxHistoryItems.isAcceptableOrUnknown(
              data['max_history_items']!, _maxHistoryItemsMeta));
    }
    if (data.containsKey('retention_days')) {
      context.handle(
          _retentionDaysMeta,
          retentionDays.isAcceptableOrUnknown(
              data['retention_days']!, _retentionDaysMeta));
    }
    if (data.containsKey('pin_on_top')) {
      context.handle(_pinOnTopMeta,
          pinOnTop.isAcceptableOrUnknown(data['pin_on_top']!, _pinOnTopMeta));
    }
    if (data.containsKey('show_source_app')) {
      context.handle(
          _showSourceAppMeta,
          showSourceApp.isAcceptableOrUnknown(
              data['show_source_app']!, _showSourceAppMeta));
    }
    if (data.containsKey('preview_images')) {
      context.handle(
          _previewImagesMeta,
          previewImages.isAcceptableOrUnknown(
              data['preview_images']!, _previewImagesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  
  @override
  UserSettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsEntry(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      shortcutsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shortcuts_json'])!,
      autoSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_sync'])!,
      syncIntervalMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}sync_interval_minutes'])!,
      maxHistoryItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_history_items'])!,
      retentionDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retention_days'])!,
      pinOnTop: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pin_on_top'])!,
      showSourceApp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_source_app'])!,
      previewImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}preview_images'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserSettingsEntriesTable createAlias(String alias) {
    return $UserSettingsEntriesTable(attachedDatabase, alias);
  }
}

class UserSettingsEntry extends DataClass
    implements Insertable<UserSettingsEntry> {
  final String userId;
  final String theme;
  final String shortcutsJson;
  final bool autoSync;
  final int syncIntervalMinutes;
  final int maxHistoryItems;
  final int retentionDays;
  final bool pinOnTop;
  final bool showSourceApp;
  final bool previewImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSettingsEntry({
    required this.userId,
    required this.theme,
    required this.shortcutsJson,
    required this.autoSync,
    required this.syncIntervalMinutes,
    required this.maxHistoryItems,
    required this.retentionDays,
    required this.pinOnTop,
    required this.showSourceApp,
    required this.previewImages,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['theme'] = Variable<String>(theme);
    map['shortcuts_json'] = Variable<String>(shortcutsJson);
    map['auto_sync'] = Variable<bool>(autoSync);
    map['sync_interval_minutes'] = Variable<int>(syncIntervalMinutes);
    map['max_history_items'] = Variable<int>(maxHistoryItems);
    map['retention_days'] = Variable<int>(retentionDays);
    map['pin_on_top'] = Variable<bool>(pinOnTop);
    map['show_source_app'] = Variable<bool>(showSourceApp);
    map['preview_images'] = Variable<bool>(previewImages);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsEntriesCompanion(
      userId: Value(userId),
      theme: Value(theme),
      shortcutsJson: Value(shortcutsJson),
      autoSync: Value(autoSync),
      syncIntervalMinutes: Value(syncIntervalMinutes),
      maxHistoryItems: Value(maxHistoryItems),
      retentionDays: Value(retentionDays),
      pinOnTop: Value(pinOnTop),
      showSourceApp: Value(showSourceApp),
      previewImages: Value(previewImages),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntry(
      userId: serializer.fromJson<String>(json['userId']),
      theme: serializer.fromJson<String>(json['theme']),
      shortcutsJson: serializer.fromJson<String>(json['shortcutsJson']),
      autoSync: serializer.fromJson<bool>(json['autoSync']),
      syncIntervalMinutes: serializer.fromJson<int>(json['syncIntervalMinutes']),
      maxHistoryItems: serializer.fromJson<int>(json['maxHistoryItems']),
      retentionDays: serializer.fromJson<int>(json['retentionDays']),
      pinOnTop: serializer.fromJson<bool>(json['pinOnTop']),
      showSourceApp: serializer.fromJson<bool>(json['showSourceApp']),
      previewImages: serializer.fromJson<bool>(json['previewImages']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'theme': serializer.toJson<String>(theme),
      'shortcutsJson': serializer.toJson<String>(shortcutsJson),
      'autoSync': serializer.toJson<bool>(autoSync),
      'syncIntervalMinutes': serializer.toJson<int>(syncIntervalMinutes),
      'maxHistoryItems': serializer.toJson<int>(maxHistoryItems),
      'retentionDays': serializer.toJson<int>(retentionDays),
      'pinOnTop': serializer.toJson<bool>(pinOnTop),
      'showSourceApp': serializer.toJson<bool>(showSourceApp),
      'previewImages': serializer.toJson<bool>(previewImages),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsEntry copyWith({
    String? userId,
    String? theme,
    String? shortcutsJson,
    bool? autoSync,
    int? syncIntervalMinutes,
    int? maxHistoryItems,
    int? retentionDays,
    bool? pinOnTop,
    bool? showSourceApp,
    bool? previewImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserSettingsEntry(
        userId: userId ?? this.userId,
        theme: theme ?? this.theme,
        shortcutsJson: shortcutsJson ?? this.shortcutsJson,
        autoSync: autoSync ?? this.autoSync,
        syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
        maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
        retentionDays: retentionDays ?? this.retentionDays,
        pinOnTop: pinOnTop ?? this.pinOnTop,
        showSourceApp: showSourceApp ?? this.showSourceApp,
        previewImages: previewImages ?? this.previewImages,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntry(')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('shortcutsJson: $shortcutsJson, ')
          ..write('autoSync: $autoSync, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('maxHistoryItems: $maxHistoryItems, ')
          ..write('retentionDays: $retentionDays, ')
          ..write('pinOnTop: $pinOnTop, ')
          ..write('showSourceApp: $showSourceApp, ')
          ..write('previewImages: $previewImages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        userId,
        theme,
        shortcutsJson,
        autoSync,
        syncIntervalMinutes,
        maxHistoryItems,
        retentionDays,
        pinOnTop,
        showSourceApp,
        previewImages,
        createdAt,
        updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsEntry &&
          other.userId == this.userId &&
          other.theme == this.theme &&
          other.shortcutsJson == this.shortcutsJson &&
          other.autoSync == this.autoSync &&
          other.syncIntervalMinutes == this.syncIntervalMinutes &&
          other.maxHistoryItems == this.maxHistoryItems &&
          other.retentionDays == this.retentionDays &&
          other.pinOnTop == this.pinOnTop &&
          other.showSourceApp == this.showSourceApp &&
          other.previewImages == this.previewImages &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsEntriesCompanion extends UpdateCompanion<UserSettingsEntry> {
  final Value<String> userId;
  final Value<String> theme;
  final Value<String> shortcutsJson;
  final Value<bool> autoSync;
  final Value<int> syncIntervalMinutes;
  final Value<int> maxHistoryItems;
  final Value<int> retentionDays;
  final Value<bool> pinOnTop;
  final Value<bool> showSourceApp;
  final Value<bool> previewImages;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;

  const UserSettingsEntriesCompanion({
    this.userId = const Value.absent(),
    this.theme = const Value.absent(),
    this.shortcutsJson = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.maxHistoryItems = const Value.absent(),
    this.retentionDays = const Value.absent(),
    this.pinOnTop = const Value.absent(),
    this.showSourceApp = const Value.absent(),
    this.previewImages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  UserSettingsEntriesCompanion.insert({
    required String userId,
    this.theme = const Value.absent(),
    this.shortcutsJson = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.maxHistoryItems = const Value.absent(),
    this.retentionDays = const Value.absent(),
    this.pinOnTop = const Value.absent(),
    this.showSourceApp = const Value.absent(),
    this.previewImages = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);

  static Insertable<UserSettingsEntry> custom({
    Expression<String>? userId,
    Expression<String>? theme,
    Expression<String>? shortcutsJson,
    Expression<bool>? autoSync,
    Expression<int>? syncIntervalMinutes,
    Expression<int>? maxHistoryItems,
    Expression<int>? retentionDays,
    Expression<bool>? pinOnTop,
    Expression<bool>? showSourceApp,
    Expression<bool>? previewImages,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (theme != null) 'theme': theme,
      if (shortcutsJson != null) 'shortcuts_json': shortcutsJson,
      if (autoSync != null) 'auto_sync': autoSync,
      if (syncIntervalMinutes != null)
        'sync_interval_minutes': syncIntervalMinutes,
      if (maxHistoryItems != null) 'max_history_items': maxHistoryItems,
      if (retentionDays != null) 'retention_days': retentionDays,
      if (pinOnTop != null) 'pin_on_top': pinOnTop,
      if (showSourceApp != null) 'show_source_app': showSourceApp,
      if (previewImages != null) 'preview_images': previewImages,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsEntriesCompanion copyWith({
    Value<String>? userId,
    Value<String>? theme,
    Value<String>? shortcutsJson,
    Value<bool>? autoSync,
    Value<int>? syncIntervalMinutes,
    Value<int>? maxHistoryItems,
    Value<int>? retentionDays,
    Value<bool>? pinOnTop,
    Value<bool>? showSourceApp,
    Value<bool>? previewImages,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsEntriesCompanion(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      shortcutsJson: shortcutsJson ?? this.shortcutsJson,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      retentionDays: retentionDays ?? this.retentionDays,
      pinOnTop: pinOnTop ?? this.pinOnTop,
      showSourceApp: showSourceApp ?? this.showSourceApp,
      previewImages: previewImages ?? this.previewImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (shortcutsJson.present) {
      map['shortcuts_json'] = Variable<String>(shortcutsJson.value);
    }
    if (autoSync.present) {
      map['auto_sync'] = Variable<bool>(autoSync.value);
    }
    if (syncIntervalMinutes.present) {
      map['sync_interval_minutes'] = Variable<int>(syncIntervalMinutes.value);
    }
    if (maxHistoryItems.present) {
      map['max_history_items'] = Variable<int>(maxHistoryItems.value);
    }
    if (retentionDays.present) {
      map['retention_days'] = Variable<int>(retentionDays.value);
    }
    if (pinOnTop.present) {
      map['pin_on_top'] = Variable<bool>(pinOnTop.value);
    }
    if (showSourceApp.present) {
      map['show_source_app'] = Variable<bool>(showSourceApp.value);
    }
    if (previewImages.present) {
      map['preview_images'] = Variable<bool>(previewImages.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntriesCompanion(')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('shortcutsJson: $shortcutsJson, ')
          ..write('autoSync: $autoSync, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('maxHistoryItems: $maxHistoryItems, ')
          ..write('retentionDays: $retentionDays, ')
          ..write('pinOnTop: $pinOnTop, ')
          ..write('showSourceApp: $showSourceApp, ')
          ..write('previewImages: $previewImages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SettingsDatabase extends GeneratedDatabase {
  _$SettingsDatabase(QueryExecutor e) : super(e);
  late final $UserSettingsEntriesTable userSettingsEntries =
      $UserSettingsEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userSettingsEntries];
}

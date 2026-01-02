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
  static const VerificationMeta _shortcutsJsonMeta = const VerificationMeta(
    'shortcutsJson',
  );
  @override
  late final GeneratedColumn<String> shortcutsJson = GeneratedColumn<String>(
    'shortcuts_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _autoSyncMeta = const VerificationMeta(
    'autoSync',
  );
  @override
  late final GeneratedColumn<bool> autoSync = GeneratedColumn<bool>(
    'auto_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _incognitoModeMeta = const VerificationMeta(
    'incognitoMode',
  );
  @override
  late final GeneratedColumn<bool> incognitoMode = GeneratedColumn<bool>(
    'incognito_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("incognito_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncIntervalMinutesMeta =
      const VerificationMeta('syncIntervalMinutes');
  @override
  late final GeneratedColumn<int> syncIntervalMinutes = GeneratedColumn<int>(
    'sync_interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _maxHistoryItemsMeta = const VerificationMeta(
    'maxHistoryItems',
  );
  @override
  late final GeneratedColumn<int> maxHistoryItems = GeneratedColumn<int>(
    'max_history_items',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _retentionDaysMeta = const VerificationMeta(
    'retentionDays',
  );
  @override
  late final GeneratedColumn<int> retentionDays = GeneratedColumn<int>(
    'retention_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _showSourceAppMeta = const VerificationMeta(
    'showSourceApp',
  );
  @override
  late final GeneratedColumn<bool> showSourceApp = GeneratedColumn<bool>(
    'show_source_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_source_app" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _previewImagesMeta = const VerificationMeta(
    'previewImages',
  );
  @override
  late final GeneratedColumn<bool> previewImages = GeneratedColumn<bool>(
    'preview_images',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("preview_images" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _previewLinksMeta = const VerificationMeta(
    'previewLinks',
  );
  @override
  late final GeneratedColumn<bool> previewLinks = GeneratedColumn<bool>(
    'preview_links',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("preview_links" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    theme,
    shortcutsJson,
    autoSync,
    incognitoMode,
    syncIntervalMinutes,
    maxHistoryItems,
    retentionDays,
    showSourceApp,
    previewImages,
    previewLinks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('shortcuts_json')) {
      context.handle(
        _shortcutsJsonMeta,
        shortcutsJson.isAcceptableOrUnknown(
          data['shortcuts_json']!,
          _shortcutsJsonMeta,
        ),
      );
    }
    if (data.containsKey('auto_sync')) {
      context.handle(
        _autoSyncMeta,
        autoSync.isAcceptableOrUnknown(data['auto_sync']!, _autoSyncMeta),
      );
    }
    if (data.containsKey('incognito_mode')) {
      context.handle(
        _incognitoModeMeta,
        incognitoMode.isAcceptableOrUnknown(
          data['incognito_mode']!,
          _incognitoModeMeta,
        ),
      );
    }
    if (data.containsKey('sync_interval_minutes')) {
      context.handle(
        _syncIntervalMinutesMeta,
        syncIntervalMinutes.isAcceptableOrUnknown(
          data['sync_interval_minutes']!,
          _syncIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('max_history_items')) {
      context.handle(
        _maxHistoryItemsMeta,
        maxHistoryItems.isAcceptableOrUnknown(
          data['max_history_items']!,
          _maxHistoryItemsMeta,
        ),
      );
    }
    if (data.containsKey('retention_days')) {
      context.handle(
        _retentionDaysMeta,
        retentionDays.isAcceptableOrUnknown(
          data['retention_days']!,
          _retentionDaysMeta,
        ),
      );
    }
    if (data.containsKey('show_source_app')) {
      context.handle(
        _showSourceAppMeta,
        showSourceApp.isAcceptableOrUnknown(
          data['show_source_app']!,
          _showSourceAppMeta,
        ),
      );
    }
    if (data.containsKey('preview_images')) {
      context.handle(
        _previewImagesMeta,
        previewImages.isAcceptableOrUnknown(
          data['preview_images']!,
          _previewImagesMeta,
        ),
      );
    }
    if (data.containsKey('preview_links')) {
      context.handle(
        _previewLinksMeta,
        previewLinks.isAcceptableOrUnknown(
          data['preview_links']!,
          _previewLinksMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
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
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      shortcutsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shortcuts_json'],
      )!,
      autoSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_sync'],
      )!,
      incognitoMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}incognito_mode'],
      )!,
      syncIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_interval_minutes'],
      )!,
      maxHistoryItems: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_history_items'],
      )!,
      retentionDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retention_days'],
      )!,
      showSourceApp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_source_app'],
      )!,
      previewImages: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}preview_images'],
      )!,
      previewLinks: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}preview_links'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final bool incognitoMode;
  final int syncIntervalMinutes;
  final int maxHistoryItems;
  final int retentionDays;
  final bool showSourceApp;
  final bool previewImages;
  final bool previewLinks;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserSettingsEntry({
    required this.userId,
    required this.theme,
    required this.shortcutsJson,
    required this.autoSync,
    required this.incognitoMode,
    required this.syncIntervalMinutes,
    required this.maxHistoryItems,
    required this.retentionDays,
    required this.showSourceApp,
    required this.previewImages,
    required this.previewLinks,
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
    map['incognito_mode'] = Variable<bool>(incognitoMode);
    map['sync_interval_minutes'] = Variable<int>(syncIntervalMinutes);
    map['max_history_items'] = Variable<int>(maxHistoryItems);
    map['retention_days'] = Variable<int>(retentionDays);
    map['show_source_app'] = Variable<bool>(showSourceApp);
    map['preview_images'] = Variable<bool>(previewImages);
    map['preview_links'] = Variable<bool>(previewLinks);
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
      incognitoMode: Value(incognitoMode),
      syncIntervalMinutes: Value(syncIntervalMinutes),
      maxHistoryItems: Value(maxHistoryItems),
      retentionDays: Value(retentionDays),
      showSourceApp: Value(showSourceApp),
      previewImages: Value(previewImages),
      previewLinks: Value(previewLinks),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntry(
      userId: serializer.fromJson<String>(json['userId']),
      theme: serializer.fromJson<String>(json['theme']),
      shortcutsJson: serializer.fromJson<String>(json['shortcutsJson']),
      autoSync: serializer.fromJson<bool>(json['autoSync']),
      incognitoMode: serializer.fromJson<bool>(json['incognitoMode']),
      syncIntervalMinutes: serializer.fromJson<int>(
        json['syncIntervalMinutes'],
      ),
      maxHistoryItems: serializer.fromJson<int>(json['maxHistoryItems']),
      retentionDays: serializer.fromJson<int>(json['retentionDays']),
      showSourceApp: serializer.fromJson<bool>(json['showSourceApp']),
      previewImages: serializer.fromJson<bool>(json['previewImages']),
      previewLinks: serializer.fromJson<bool>(json['previewLinks']),
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
      'incognitoMode': serializer.toJson<bool>(incognitoMode),
      'syncIntervalMinutes': serializer.toJson<int>(syncIntervalMinutes),
      'maxHistoryItems': serializer.toJson<int>(maxHistoryItems),
      'retentionDays': serializer.toJson<int>(retentionDays),
      'showSourceApp': serializer.toJson<bool>(showSourceApp),
      'previewImages': serializer.toJson<bool>(previewImages),
      'previewLinks': serializer.toJson<bool>(previewLinks),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsEntry copyWith({
    String? userId,
    String? theme,
    String? shortcutsJson,
    bool? autoSync,
    bool? incognitoMode,
    int? syncIntervalMinutes,
    int? maxHistoryItems,
    int? retentionDays,
    bool? showSourceApp,
    bool? previewImages,
    bool? previewLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserSettingsEntry(
    userId: userId ?? this.userId,
    theme: theme ?? this.theme,
    shortcutsJson: shortcutsJson ?? this.shortcutsJson,
    autoSync: autoSync ?? this.autoSync,
    incognitoMode: incognitoMode ?? this.incognitoMode,
    syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
    maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
    retentionDays: retentionDays ?? this.retentionDays,
    showSourceApp: showSourceApp ?? this.showSourceApp,
    previewImages: previewImages ?? this.previewImages,
    previewLinks: previewLinks ?? this.previewLinks,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSettingsEntry copyWithCompanion(UserSettingsEntriesCompanion data) {
    return UserSettingsEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      theme: data.theme.present ? data.theme.value : this.theme,
      shortcutsJson: data.shortcutsJson.present
          ? data.shortcutsJson.value
          : this.shortcutsJson,
      autoSync: data.autoSync.present ? data.autoSync.value : this.autoSync,
      incognitoMode: data.incognitoMode.present
          ? data.incognitoMode.value
          : this.incognitoMode,
      syncIntervalMinutes: data.syncIntervalMinutes.present
          ? data.syncIntervalMinutes.value
          : this.syncIntervalMinutes,
      maxHistoryItems: data.maxHistoryItems.present
          ? data.maxHistoryItems.value
          : this.maxHistoryItems,
      retentionDays: data.retentionDays.present
          ? data.retentionDays.value
          : this.retentionDays,
      showSourceApp: data.showSourceApp.present
          ? data.showSourceApp.value
          : this.showSourceApp,
      previewImages: data.previewImages.present
          ? data.previewImages.value
          : this.previewImages,
      previewLinks: data.previewLinks.present
          ? data.previewLinks.value
          : this.previewLinks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntry(')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('shortcutsJson: $shortcutsJson, ')
          ..write('autoSync: $autoSync, ')
          ..write('incognitoMode: $incognitoMode, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('maxHistoryItems: $maxHistoryItems, ')
          ..write('retentionDays: $retentionDays, ')
          ..write('showSourceApp: $showSourceApp, ')
          ..write('previewImages: $previewImages, ')
          ..write('previewLinks: $previewLinks, ')
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
    incognitoMode,
    syncIntervalMinutes,
    maxHistoryItems,
    retentionDays,
    showSourceApp,
    previewImages,
    previewLinks,
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
          other.incognitoMode == this.incognitoMode &&
          other.syncIntervalMinutes == this.syncIntervalMinutes &&
          other.maxHistoryItems == this.maxHistoryItems &&
          other.retentionDays == this.retentionDays &&
          other.showSourceApp == this.showSourceApp &&
          other.previewImages == this.previewImages &&
          other.previewLinks == this.previewLinks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsEntriesCompanion extends UpdateCompanion<UserSettingsEntry> {
  final Value<String> userId;
  final Value<String> theme;
  final Value<String> shortcutsJson;
  final Value<bool> autoSync;
  final Value<bool> incognitoMode;
  final Value<int> syncIntervalMinutes;
  final Value<int> maxHistoryItems;
  final Value<int> retentionDays;
  final Value<bool> showSourceApp;
  final Value<bool> previewImages;
  final Value<bool> previewLinks;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserSettingsEntriesCompanion({
    this.userId = const Value.absent(),
    this.theme = const Value.absent(),
    this.shortcutsJson = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.incognitoMode = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.maxHistoryItems = const Value.absent(),
    this.retentionDays = const Value.absent(),
    this.showSourceApp = const Value.absent(),
    this.previewImages = const Value.absent(),
    this.previewLinks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsEntriesCompanion.insert({
    required String userId,
    this.theme = const Value.absent(),
    this.shortcutsJson = const Value.absent(),
    this.autoSync = const Value.absent(),
    this.incognitoMode = const Value.absent(),
    this.syncIntervalMinutes = const Value.absent(),
    this.maxHistoryItems = const Value.absent(),
    this.retentionDays = const Value.absent(),
    this.showSourceApp = const Value.absent(),
    this.previewImages = const Value.absent(),
    this.previewLinks = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserSettingsEntry> custom({
    Expression<String>? userId,
    Expression<String>? theme,
    Expression<String>? shortcutsJson,
    Expression<bool>? autoSync,
    Expression<bool>? incognitoMode,
    Expression<int>? syncIntervalMinutes,
    Expression<int>? maxHistoryItems,
    Expression<int>? retentionDays,
    Expression<bool>? showSourceApp,
    Expression<bool>? previewImages,
    Expression<bool>? previewLinks,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (theme != null) 'theme': theme,
      if (shortcutsJson != null) 'shortcuts_json': shortcutsJson,
      if (autoSync != null) 'auto_sync': autoSync,
      if (incognitoMode != null) 'incognito_mode': incognitoMode,
      if (syncIntervalMinutes != null)
        'sync_interval_minutes': syncIntervalMinutes,
      if (maxHistoryItems != null) 'max_history_items': maxHistoryItems,
      if (retentionDays != null) 'retention_days': retentionDays,
      if (showSourceApp != null) 'show_source_app': showSourceApp,
      if (previewImages != null) 'preview_images': previewImages,
      if (previewLinks != null) 'preview_links': previewLinks,
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
    Value<bool>? incognitoMode,
    Value<int>? syncIntervalMinutes,
    Value<int>? maxHistoryItems,
    Value<int>? retentionDays,
    Value<bool>? showSourceApp,
    Value<bool>? previewImages,
    Value<bool>? previewLinks,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsEntriesCompanion(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      shortcutsJson: shortcutsJson ?? this.shortcutsJson,
      autoSync: autoSync ?? this.autoSync,
      incognitoMode: incognitoMode ?? this.incognitoMode,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      retentionDays: retentionDays ?? this.retentionDays,
      showSourceApp: showSourceApp ?? this.showSourceApp,
      previewImages: previewImages ?? this.previewImages,
      previewLinks: previewLinks ?? this.previewLinks,
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
    if (incognitoMode.present) {
      map['incognito_mode'] = Variable<bool>(incognitoMode.value);
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
    if (showSourceApp.present) {
      map['show_source_app'] = Variable<bool>(showSourceApp.value);
    }
    if (previewImages.present) {
      map['preview_images'] = Variable<bool>(previewImages.value);
    }
    if (previewLinks.present) {
      map['preview_links'] = Variable<bool>(previewLinks.value);
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
          ..write('incognitoMode: $incognitoMode, ')
          ..write('syncIntervalMinutes: $syncIntervalMinutes, ')
          ..write('maxHistoryItems: $maxHistoryItems, ')
          ..write('retentionDays: $retentionDays, ')
          ..write('showSourceApp: $showSourceApp, ')
          ..write('previewImages: $previewImages, ')
          ..write('previewLinks: $previewLinks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SettingsDatabase extends GeneratedDatabase {
  _$SettingsDatabase(QueryExecutor e) : super(e);
  $SettingsDatabaseManager get managers => $SettingsDatabaseManager(this);
  late final $UserSettingsEntriesTable userSettingsEntries =
      $UserSettingsEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userSettingsEntries];
}

typedef $$UserSettingsEntriesTableCreateCompanionBuilder =
    UserSettingsEntriesCompanion Function({
      required String userId,
      Value<String> theme,
      Value<String> shortcutsJson,
      Value<bool> autoSync,
      Value<bool> incognitoMode,
      Value<int> syncIntervalMinutes,
      Value<int> maxHistoryItems,
      Value<int> retentionDays,
      Value<bool> showSourceApp,
      Value<bool> previewImages,
      Value<bool> previewLinks,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsEntriesTableUpdateCompanionBuilder =
    UserSettingsEntriesCompanion Function({
      Value<String> userId,
      Value<String> theme,
      Value<String> shortcutsJson,
      Value<bool> autoSync,
      Value<bool> incognitoMode,
      Value<int> syncIntervalMinutes,
      Value<int> maxHistoryItems,
      Value<int> retentionDays,
      Value<bool> showSourceApp,
      Value<bool> previewImages,
      Value<bool> previewLinks,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserSettingsEntriesTableFilterComposer
    extends Composer<_$SettingsDatabase, $UserSettingsEntriesTable> {
  $$UserSettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortcutsJson => $composableBuilder(
    column: $table.shortcutsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSync => $composableBuilder(
    column: $table.autoSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get incognitoMode => $composableBuilder(
    column: $table.incognitoMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHistoryItems => $composableBuilder(
    column: $table.maxHistoryItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retentionDays => $composableBuilder(
    column: $table.retentionDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showSourceApp => $composableBuilder(
    column: $table.showSourceApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get previewImages => $composableBuilder(
    column: $table.previewImages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get previewLinks => $composableBuilder(
    column: $table.previewLinks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsEntriesTableOrderingComposer
    extends Composer<_$SettingsDatabase, $UserSettingsEntriesTable> {
  $$UserSettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortcutsJson => $composableBuilder(
    column: $table.shortcutsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSync => $composableBuilder(
    column: $table.autoSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get incognitoMode => $composableBuilder(
    column: $table.incognitoMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHistoryItems => $composableBuilder(
    column: $table.maxHistoryItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retentionDays => $composableBuilder(
    column: $table.retentionDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showSourceApp => $composableBuilder(
    column: $table.showSourceApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get previewImages => $composableBuilder(
    column: $table.previewImages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get previewLinks => $composableBuilder(
    column: $table.previewLinks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsEntriesTableAnnotationComposer
    extends Composer<_$SettingsDatabase, $UserSettingsEntriesTable> {
  $$UserSettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get shortcutsJson => $composableBuilder(
    column: $table.shortcutsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSync =>
      $composableBuilder(column: $table.autoSync, builder: (column) => column);

  GeneratedColumn<bool> get incognitoMode => $composableBuilder(
    column: $table.incognitoMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncIntervalMinutes => $composableBuilder(
    column: $table.syncIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxHistoryItems => $composableBuilder(
    column: $table.maxHistoryItems,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retentionDays => $composableBuilder(
    column: $table.retentionDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showSourceApp => $composableBuilder(
    column: $table.showSourceApp,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get previewImages => $composableBuilder(
    column: $table.previewImages,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get previewLinks => $composableBuilder(
    column: $table.previewLinks,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$SettingsDatabase,
          $UserSettingsEntriesTable,
          UserSettingsEntry,
          $$UserSettingsEntriesTableFilterComposer,
          $$UserSettingsEntriesTableOrderingComposer,
          $$UserSettingsEntriesTableAnnotationComposer,
          $$UserSettingsEntriesTableCreateCompanionBuilder,
          $$UserSettingsEntriesTableUpdateCompanionBuilder,
          (
            UserSettingsEntry,
            BaseReferences<
              _$SettingsDatabase,
              $UserSettingsEntriesTable,
              UserSettingsEntry
            >,
          ),
          UserSettingsEntry,
          PrefetchHooks Function()
        > {
  $$UserSettingsEntriesTableTableManager(
    _$SettingsDatabase db,
    $UserSettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserSettingsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> shortcutsJson = const Value.absent(),
                Value<bool> autoSync = const Value.absent(),
                Value<bool> incognitoMode = const Value.absent(),
                Value<int> syncIntervalMinutes = const Value.absent(),
                Value<int> maxHistoryItems = const Value.absent(),
                Value<int> retentionDays = const Value.absent(),
                Value<bool> showSourceApp = const Value.absent(),
                Value<bool> previewImages = const Value.absent(),
                Value<bool> previewLinks = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsEntriesCompanion(
                userId: userId,
                theme: theme,
                shortcutsJson: shortcutsJson,
                autoSync: autoSync,
                incognitoMode: incognitoMode,
                syncIntervalMinutes: syncIntervalMinutes,
                maxHistoryItems: maxHistoryItems,
                retentionDays: retentionDays,
                showSourceApp: showSourceApp,
                previewImages: previewImages,
                previewLinks: previewLinks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<String> theme = const Value.absent(),
                Value<String> shortcutsJson = const Value.absent(),
                Value<bool> autoSync = const Value.absent(),
                Value<bool> incognitoMode = const Value.absent(),
                Value<int> syncIntervalMinutes = const Value.absent(),
                Value<int> maxHistoryItems = const Value.absent(),
                Value<int> retentionDays = const Value.absent(),
                Value<bool> showSourceApp = const Value.absent(),
                Value<bool> previewImages = const Value.absent(),
                Value<bool> previewLinks = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsEntriesCompanion.insert(
                userId: userId,
                theme: theme,
                shortcutsJson: shortcutsJson,
                autoSync: autoSync,
                incognitoMode: incognitoMode,
                syncIntervalMinutes: syncIntervalMinutes,
                maxHistoryItems: maxHistoryItems,
                retentionDays: retentionDays,
                showSourceApp: showSourceApp,
                previewImages: previewImages,
                previewLinks: previewLinks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$SettingsDatabase,
      $UserSettingsEntriesTable,
      UserSettingsEntry,
      $$UserSettingsEntriesTableFilterComposer,
      $$UserSettingsEntriesTableOrderingComposer,
      $$UserSettingsEntriesTableAnnotationComposer,
      $$UserSettingsEntriesTableCreateCompanionBuilder,
      $$UserSettingsEntriesTableUpdateCompanionBuilder,
      (
        UserSettingsEntry,
        BaseReferences<
          _$SettingsDatabase,
          $UserSettingsEntriesTable,
          UserSettingsEntry
        >,
      ),
      UserSettingsEntry,
      PrefetchHooks Function()
    >;

class $SettingsDatabaseManager {
  final _$SettingsDatabase _db;
  $SettingsDatabaseManager(this._db);
  $$UserSettingsEntriesTableTableManager get userSettingsEntries =>
      $$UserSettingsEntriesTableTableManager(_db, _db.userSettingsEntries);
}

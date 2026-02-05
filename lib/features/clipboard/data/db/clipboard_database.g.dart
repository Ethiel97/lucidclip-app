// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_database.dart';

// ignore_for_file: type=lint
class $ClipboardItemEntriesTable extends ClipboardItemEntries
    with TableInfo<$ClipboardItemEntriesTable, ClipboardItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $ClipboardItemEntriesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
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
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('clean'),
  );
  static const VerificationMeta _lastModifiedByDeviceIdMeta =
      const VerificationMeta('lastModifiedByDeviceId');
  @override
  late final GeneratedColumn<String> lastModifiedByDeviceId =
      GeneratedColumn<String>(
        'last_modified_by_device_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _htmlContentMeta = const VerificationMeta(
    'htmlContent',
  );
  @override
  late final GeneratedColumn<String> htmlContent = GeneratedColumn<String>(
    'html_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageBytesMeta = const VerificationMeta(
    'imageBytes',
  );
  @override
  late final GeneratedColumn<String> imageBytes = GeneratedColumn<String>(
    'image_bytes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSnippetMeta = const VerificationMeta(
    'isSnippet',
  );
  @override
  late final GeneratedColumn<bool> isSnippet = GeneratedColumn<bool>(
    'is_snippet',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_snippet" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );

  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    contentHash,
    userId,
    usageCount,
    type,
    createdAt,
    updatedAt,
    deletedAt,
    version,
    syncStatus,
    lastModifiedByDeviceId,
    lastUsedAt,
    htmlContent,
    imageBytes,
    filePath,
    isPinned,
    isSnippet,
    metadataJson,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'clipboard_item_entries';

  @override
  VerificationContext validateIntegrity(
    Insertable<ClipboardItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_modified_by_device_id')) {
      context.handle(
        _lastModifiedByDeviceIdMeta,
        lastModifiedByDeviceId.isAcceptableOrUnknown(
          data['last_modified_by_device_id']!,
          _lastModifiedByDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('html_content')) {
      context.handle(
        _htmlContentMeta,
        htmlContent.isAcceptableOrUnknown(
          data['html_content']!,
          _htmlContentMeta,
        ),
      );
    }
    if (data.containsKey('image_bytes')) {
      context.handle(
        _imageBytesMeta,
        imageBytes.isAcceptableOrUnknown(data['image_bytes']!, _imageBytesMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_snippet')) {
      context.handle(
        _isSnippetMeta,
        isSnippet.isAcceptableOrUnknown(data['is_snippet']!, _isSnippetMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  ClipboardItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClipboardItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastModifiedByDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified_by_device_id'],
      ),
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      htmlContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}html_content'],
      ),
      imageBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_bytes'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isSnippet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_snippet'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
    );
  }

  @override
  $ClipboardItemEntriesTable createAlias(String alias) {
    return $ClipboardItemEntriesTable(attachedDatabase, alias);
  }
}

class ClipboardItemEntry extends DataClass
    implements Insertable<ClipboardItemEntry> {
  final String id;
  final String content;
  final String contentHash;
  final String userId;
  final int usageCount;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  final String syncStatus;
  final String? lastModifiedByDeviceId;
  final DateTime? lastUsedAt;
  final String? htmlContent;
  final String? imageBytes;
  final String? filePath;
  final bool isPinned;
  final bool isSnippet;
  final String? metadataJson;

  const ClipboardItemEntry({
    required this.id,
    required this.content,
    required this.contentHash,
    required this.userId,
    required this.usageCount,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
    required this.syncStatus,
    this.lastModifiedByDeviceId,
    this.lastUsedAt,
    this.htmlContent,
    this.imageBytes,
    this.filePath,
    required this.isPinned,
    required this.isSnippet,
    this.metadataJson,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['content_hash'] = Variable<String>(contentHash);
    map['user_id'] = Variable<String>(userId);
    map['usage_count'] = Variable<int>(usageCount);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastModifiedByDeviceId != null) {
      map['last_modified_by_device_id'] = Variable<String>(
        lastModifiedByDeviceId,
      );
    }
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    if (!nullToAbsent || htmlContent != null) {
      map['html_content'] = Variable<String>(htmlContent);
    }
    if (!nullToAbsent || imageBytes != null) {
      map['image_bytes'] = Variable<String>(imageBytes);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_snippet'] = Variable<bool>(isSnippet);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  ClipboardItemEntriesCompanion toCompanion(bool nullToAbsent) {
    return ClipboardItemEntriesCompanion(
      id: Value(id),
      content: Value(content),
      contentHash: Value(contentHash),
      userId: Value(userId),
      usageCount: Value(usageCount),
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
      syncStatus: Value(syncStatus),
      lastModifiedByDeviceId: lastModifiedByDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModifiedByDeviceId),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      htmlContent: htmlContent == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlContent),
      imageBytes: imageBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(imageBytes),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      isPinned: Value(isPinned),
      isSnippet: Value(isSnippet),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory ClipboardItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClipboardItemEntry(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      userId: serializer.fromJson<String>(json['userId']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastModifiedByDeviceId: serializer.fromJson<String?>(
        json['lastModifiedByDeviceId'],
      ),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      htmlContent: serializer.fromJson<String?>(json['htmlContent']),
      imageBytes: serializer.fromJson<String?>(json['imageBytes']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isSnippet: serializer.fromJson<bool>(json['isSnippet']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'contentHash': serializer.toJson<String>(contentHash),
      'userId': serializer.toJson<String>(userId),
      'usageCount': serializer.toJson<int>(usageCount),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastModifiedByDeviceId': serializer.toJson<String?>(
        lastModifiedByDeviceId,
      ),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'htmlContent': serializer.toJson<String?>(htmlContent),
      'imageBytes': serializer.toJson<String?>(imageBytes),
      'filePath': serializer.toJson<String?>(filePath),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isSnippet': serializer.toJson<bool>(isSnippet),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  ClipboardItemEntry copyWith({
    String? id,
    String? content,
    String? contentHash,
    String? userId,
    int? usageCount,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
    String? syncStatus,
    Value<String?> lastModifiedByDeviceId = const Value.absent(),
    Value<DateTime?> lastUsedAt = const Value.absent(),
    Value<String?> htmlContent = const Value.absent(),
    Value<String?> imageBytes = const Value.absent(),
    Value<String?> filePath = const Value.absent(),
    bool? isPinned,
    bool? isSnippet,
    Value<String?> metadataJson = const Value.absent(),
  }) => ClipboardItemEntry(
    id: id ?? this.id,
    content: content ?? this.content,
    contentHash: contentHash ?? this.contentHash,
    userId: userId ?? this.userId,
    usageCount: usageCount ?? this.usageCount,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
    syncStatus: syncStatus ?? this.syncStatus,
    lastModifiedByDeviceId: lastModifiedByDeviceId.present
        ? lastModifiedByDeviceId.value
        : this.lastModifiedByDeviceId,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    htmlContent: htmlContent.present ? htmlContent.value : this.htmlContent,
    imageBytes: imageBytes.present ? imageBytes.value : this.imageBytes,
    filePath: filePath.present ? filePath.value : this.filePath,
    isPinned: isPinned ?? this.isPinned,
    isSnippet: isSnippet ?? this.isSnippet,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
  );

  ClipboardItemEntry copyWithCompanion(ClipboardItemEntriesCompanion data) {
    return ClipboardItemEntry(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      userId: data.userId.present ? data.userId.value : this.userId,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastModifiedByDeviceId: data.lastModifiedByDeviceId.present
          ? data.lastModifiedByDeviceId.value
          : this.lastModifiedByDeviceId,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      htmlContent: data.htmlContent.present
          ? data.htmlContent.value
          : this.htmlContent,
      imageBytes: data.imageBytes.present
          ? data.imageBytes.value
          : this.imageBytes,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isSnippet: data.isSnippet.present ? data.isSnippet.value : this.isSnippet,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClipboardItemEntry(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('contentHash: $contentHash, ')
          ..write('userId: $userId, ')
          ..write('usageCount: $usageCount, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModifiedByDeviceId: $lastModifiedByDeviceId, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('filePath: $filePath, ')
          ..write('isPinned: $isPinned, ')
          ..write('isSnippet: $isSnippet, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    contentHash,
    userId,
    usageCount,
    type,
    createdAt,
    updatedAt,
    deletedAt,
    version,
    syncStatus,
    lastModifiedByDeviceId,
    lastUsedAt,
    htmlContent,
    imageBytes,
    filePath,
    isPinned,
    isSnippet,
    metadataJson,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClipboardItemEntry &&
          other.id == this.id &&
          other.content == this.content &&
          other.contentHash == this.contentHash &&
          other.userId == this.userId &&
          other.usageCount == this.usageCount &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version &&
          other.syncStatus == this.syncStatus &&
          other.lastModifiedByDeviceId == this.lastModifiedByDeviceId &&
          other.lastUsedAt == this.lastUsedAt &&
          other.htmlContent == this.htmlContent &&
          other.imageBytes == this.imageBytes &&
          other.filePath == this.filePath &&
          other.isPinned == this.isPinned &&
          other.isSnippet == this.isSnippet &&
          other.metadataJson == this.metadataJson);
}

class ClipboardItemEntriesCompanion
    extends UpdateCompanion<ClipboardItemEntry> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> contentHash;
  final Value<String> userId;
  final Value<int> usageCount;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<String> syncStatus;
  final Value<String?> lastModifiedByDeviceId;
  final Value<DateTime?> lastUsedAt;
  final Value<String?> htmlContent;
  final Value<String?> imageBytes;
  final Value<String?> filePath;
  final Value<bool> isPinned;
  final Value<bool> isSnippet;
  final Value<String?> metadataJson;
  final Value<int> rowid;

  const ClipboardItemEntriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.userId = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModifiedByDeviceId = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isSnippet = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  ClipboardItemEntriesCompanion.insert({
    required String id,
    required String content,
    required String contentHash,
    required String userId,
    this.usageCount = const Value.absent(),
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastModifiedByDeviceId = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isSnippet = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       contentHash = Value(contentHash),
       userId = Value(userId),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);

  static Insertable<ClipboardItemEntry> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? contentHash,
    Expression<String>? userId,
    Expression<int>? usageCount,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<String>? syncStatus,
    Expression<String>? lastModifiedByDeviceId,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? htmlContent,
    Expression<String>? imageBytes,
    Expression<String>? filePath,
    Expression<bool>? isPinned,
    Expression<bool>? isSnippet,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (contentHash != null) 'content_hash': contentHash,
      if (userId != null) 'user_id': userId,
      if (usageCount != null) 'usage_count': usageCount,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastModifiedByDeviceId != null)
        'last_modified_by_device_id': lastModifiedByDeviceId,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (htmlContent != null) 'html_content': htmlContent,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (filePath != null) 'file_path': filePath,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isSnippet != null) 'is_snippet': isSnippet,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClipboardItemEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? contentHash,
    Value<String>? userId,
    Value<int>? usageCount,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<String>? syncStatus,
    Value<String?>? lastModifiedByDeviceId,
    Value<DateTime?>? lastUsedAt,
    Value<String?>? htmlContent,
    Value<String?>? imageBytes,
    Value<String?>? filePath,
    Value<bool>? isPinned,
    Value<bool>? isSnippet,
    Value<String?>? metadataJson,
    Value<int>? rowid,
  }) {
    return ClipboardItemEntriesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      userId: userId ?? this.userId,
      usageCount: usageCount ?? this.usageCount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      lastModifiedByDeviceId:
          lastModifiedByDeviceId ?? this.lastModifiedByDeviceId,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      htmlContent: htmlContent ?? this.htmlContent,
      imageBytes: imageBytes ?? this.imageBytes,
      filePath: filePath ?? this.filePath,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastModifiedByDeviceId.present) {
      map['last_modified_by_device_id'] = Variable<String>(
        lastModifiedByDeviceId.value,
      );
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (htmlContent.present) {
      map['html_content'] = Variable<String>(htmlContent.value);
    }
    if (imageBytes.present) {
      map['image_bytes'] = Variable<String>(imageBytes.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isSnippet.present) {
      map['is_snippet'] = Variable<bool>(isSnippet.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClipboardItemEntriesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('contentHash: $contentHash, ')
          ..write('userId: $userId, ')
          ..write('usageCount: $usageCount, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastModifiedByDeviceId: $lastModifiedByDeviceId, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('filePath: $filePath, ')
          ..write('isPinned: $isPinned, ')
          ..write('isSnippet: $isSnippet, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClipboardOutboxEntriesTable extends ClipboardOutboxEntries
    with TableInfo<$ClipboardOutboxEntriesTable, ClipboardOutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $ClipboardOutboxEntriesTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
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
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
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
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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

  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    entityId,
    userId,
    operationType,
    payload,
    deviceId,
    status,
    sentAt,
    retryCount,
    lastError,
    createdAt,
  ];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'clipboard_outbox_entries';

  @override
  VerificationContext validateIntegrity(
    Insertable<ClipboardOutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};

  @override
  ClipboardOutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClipboardOutboxEntry(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClipboardOutboxEntriesTable createAlias(String alias) {
    return $ClipboardOutboxEntriesTable(attachedDatabase, alias);
  }
}

class ClipboardOutboxEntry extends DataClass
    implements Insertable<ClipboardOutboxEntry> {
  final String operationId;
  final String entityId;
  final String userId;
  final String operationType;
  final String? payload;
  final String deviceId;
  final String status;
  final DateTime? sentAt;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;

  const ClipboardOutboxEntry({
    required this.operationId,
    required this.entityId,
    required this.userId,
    required this.operationType,
    this.payload,
    required this.deviceId,
    required this.status,
    this.sentAt,
    required this.retryCount,
    this.lastError,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['entity_id'] = Variable<String>(entityId);
    map['user_id'] = Variable<String>(userId);
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClipboardOutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return ClipboardOutboxEntriesCompanion(
      operationId: Value(operationId),
      entityId: Value(entityId),
      userId: Value(userId),
      operationType: Value(operationType),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      deviceId: Value(deviceId),
      status: Value(status),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory ClipboardOutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClipboardOutboxEntry(
      operationId: serializer.fromJson<String>(json['operationId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      userId: serializer.fromJson<String>(json['userId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payload: serializer.fromJson<String?>(json['payload']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      status: serializer.fromJson<String>(json['status']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'entityId': serializer.toJson<String>(entityId),
      'userId': serializer.toJson<String>(userId),
      'operationType': serializer.toJson<String>(operationType),
      'payload': serializer.toJson<String?>(payload),
      'deviceId': serializer.toJson<String>(deviceId),
      'status': serializer.toJson<String>(status),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClipboardOutboxEntry copyWith({
    String? operationId,
    String? entityId,
    String? userId,
    String? operationType,
    Value<String?> payload = const Value.absent(),
    String? deviceId,
    String? status,
    Value<DateTime?> sentAt = const Value.absent(),
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => ClipboardOutboxEntry(
    operationId: operationId ?? this.operationId,
    entityId: entityId ?? this.entityId,
    userId: userId ?? this.userId,
    operationType: operationType ?? this.operationType,
    payload: payload.present ? payload.value : this.payload,
    deviceId: deviceId ?? this.deviceId,
    status: status ?? this.status,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );

  ClipboardOutboxEntry copyWithCompanion(ClipboardOutboxEntriesCompanion data) {
    return ClipboardOutboxEntry(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      userId: data.userId.present ? data.userId.value : this.userId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payload: data.payload.present ? data.payload.value : this.payload,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      status: data.status.present ? data.status.value : this.status,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClipboardOutboxEntry(')
          ..write('operationId: $operationId, ')
          ..write('entityId: $entityId, ')
          ..write('userId: $userId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    entityId,
    userId,
    operationType,
    payload,
    deviceId,
    status,
    sentAt,
    retryCount,
    lastError,
    createdAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClipboardOutboxEntry &&
          other.operationId == this.operationId &&
          other.entityId == this.entityId &&
          other.userId == this.userId &&
          other.operationType == this.operationType &&
          other.payload == this.payload &&
          other.deviceId == this.deviceId &&
          other.status == this.status &&
          other.sentAt == this.sentAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class ClipboardOutboxEntriesCompanion
    extends UpdateCompanion<ClipboardOutboxEntry> {
  final Value<String> operationId;
  final Value<String> entityId;
  final Value<String> userId;
  final Value<String> operationType;
  final Value<String?> payload;
  final Value<String> deviceId;
  final Value<String> status;
  final Value<DateTime?> sentAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;

  const ClipboardOutboxEntriesCompanion({
    this.operationId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.userId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payload = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.status = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });

  ClipboardOutboxEntriesCompanion.insert({
    required String operationId,
    required String entityId,
    required String userId,
    required String operationType,
    this.payload = const Value.absent(),
    required String deviceId,
    this.status = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       entityId = Value(entityId),
       userId = Value(userId),
       operationType = Value(operationType),
       deviceId = Value(deviceId),
       createdAt = Value(createdAt);

  static Insertable<ClipboardOutboxEntry> custom({
    Expression<String>? operationId,
    Expression<String>? entityId,
    Expression<String>? userId,
    Expression<String>? operationType,
    Expression<String>? payload,
    Expression<String>? deviceId,
    Expression<String>? status,
    Expression<DateTime>? sentAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (entityId != null) 'entity_id': entityId,
      if (userId != null) 'user_id': userId,
      if (operationType != null) 'operation_type': operationType,
      if (payload != null) 'payload': payload,
      if (deviceId != null) 'device_id': deviceId,
      if (status != null) 'status': status,
      if (sentAt != null) 'sent_at': sentAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClipboardOutboxEntriesCompanion copyWith({
    Value<String>? operationId,
    Value<String>? entityId,
    Value<String>? userId,
    Value<String>? operationType,
    Value<String?>? payload,
    Value<String>? deviceId,
    Value<String>? status,
    Value<DateTime?>? sentAt,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ClipboardOutboxEntriesCompanion(
      operationId: operationId ?? this.operationId,
      entityId: entityId ?? this.entityId,
      userId: userId ?? this.userId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClipboardOutboxEntriesCompanion(')
          ..write('operationId: $operationId, ')
          ..write('entityId: $entityId, ')
          ..write('userId: $userId, ')
          ..write('operationType: $operationType, ')
          ..write('payload: $payload, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('sentAt: $sentAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ClipboardDatabase extends GeneratedDatabase {
  _$ClipboardDatabase(QueryExecutor e) : super(e);

  $ClipboardDatabaseManager get managers => $ClipboardDatabaseManager(this);
  late final $ClipboardItemEntriesTable clipboardItemEntries =
      $ClipboardItemEntriesTable(this);
  late final $ClipboardOutboxEntriesTable clipboardOutboxEntries =
      $ClipboardOutboxEntriesTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clipboardItemEntries,
    clipboardOutboxEntries,
  ];
}

typedef $$ClipboardItemEntriesTableCreateCompanionBuilder =
    ClipboardItemEntriesCompanion Function({
      required String id,
      required String content,
      required String contentHash,
      required String userId,
      Value<int> usageCount,
      required String type,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<String> syncStatus,
      Value<String?> lastModifiedByDeviceId,
      Value<DateTime?> lastUsedAt,
      Value<String?> htmlContent,
      Value<String?> imageBytes,
      Value<String?> filePath,
      Value<bool> isPinned,
      Value<bool> isSnippet,
      Value<String?> metadataJson,
      Value<int> rowid,
    });
typedef $$ClipboardItemEntriesTableUpdateCompanionBuilder =
    ClipboardItemEntriesCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> contentHash,
      Value<String> userId,
      Value<int> usageCount,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<String> syncStatus,
      Value<String?> lastModifiedByDeviceId,
      Value<DateTime?> lastUsedAt,
      Value<String?> htmlContent,
      Value<String?> imageBytes,
      Value<String?> filePath,
      Value<bool> isPinned,
      Value<bool> isSnippet,
      Value<String?> metadataJson,
      Value<int> rowid,
    });

class $$ClipboardItemEntriesTableFilterComposer
    extends Composer<_$ClipboardDatabase, $ClipboardItemEntriesTable> {
  $$ClipboardItemEntriesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModifiedByDeviceId => $composableBuilder(
    column: $table.lastModifiedByDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSnippet => $composableBuilder(
    column: $table.isSnippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClipboardItemEntriesTableOrderingComposer
    extends Composer<_$ClipboardDatabase, $ClipboardItemEntriesTable> {
  $$ClipboardItemEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModifiedByDeviceId => $composableBuilder(
    column: $table.lastModifiedByDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSnippet => $composableBuilder(
    column: $table.isSnippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClipboardItemEntriesTableAnnotationComposer
    extends Composer<_$ClipboardDatabase, $ClipboardItemEntriesTable> {
  $$ClipboardItemEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastModifiedByDeviceId => $composableBuilder(
    column: $table.lastModifiedByDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isSnippet =>
      $composableBuilder(column: $table.isSnippet, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$ClipboardItemEntriesTableTableManager
    extends
        RootTableManager<
          _$ClipboardDatabase,
          $ClipboardItemEntriesTable,
          ClipboardItemEntry,
          $$ClipboardItemEntriesTableFilterComposer,
          $$ClipboardItemEntriesTableOrderingComposer,
          $$ClipboardItemEntriesTableAnnotationComposer,
          $$ClipboardItemEntriesTableCreateCompanionBuilder,
          $$ClipboardItemEntriesTableUpdateCompanionBuilder,
          (
            ClipboardItemEntry,
            BaseReferences<
              _$ClipboardDatabase,
              $ClipboardItemEntriesTable,
              ClipboardItemEntry
            >,
          ),
          ClipboardItemEntry,
          PrefetchHooks Function()
        > {
  $$ClipboardItemEntriesTableTableManager(
    _$ClipboardDatabase db,
    $ClipboardItemEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClipboardItemEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClipboardItemEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClipboardItemEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastModifiedByDeviceId = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> imageBytes = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isSnippet = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardItemEntriesCompanion(
                id: id,
                content: content,
                contentHash: contentHash,
                userId: userId,
                usageCount: usageCount,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                syncStatus: syncStatus,
                lastModifiedByDeviceId: lastModifiedByDeviceId,
                lastUsedAt: lastUsedAt,
                htmlContent: htmlContent,
                imageBytes: imageBytes,
                filePath: filePath,
                isPinned: isPinned,
                isSnippet: isSnippet,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required String contentHash,
                required String userId,
                Value<int> usageCount = const Value.absent(),
                required String type,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastModifiedByDeviceId = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> imageBytes = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isSnippet = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardItemEntriesCompanion.insert(
                id: id,
                content: content,
                contentHash: contentHash,
                userId: userId,
                usageCount: usageCount,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                syncStatus: syncStatus,
                lastModifiedByDeviceId: lastModifiedByDeviceId,
                lastUsedAt: lastUsedAt,
                htmlContent: htmlContent,
                imageBytes: imageBytes,
                filePath: filePath,
                isPinned: isPinned,
                isSnippet: isSnippet,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClipboardItemEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ClipboardDatabase,
      $ClipboardItemEntriesTable,
      ClipboardItemEntry,
      $$ClipboardItemEntriesTableFilterComposer,
      $$ClipboardItemEntriesTableOrderingComposer,
      $$ClipboardItemEntriesTableAnnotationComposer,
      $$ClipboardItemEntriesTableCreateCompanionBuilder,
      $$ClipboardItemEntriesTableUpdateCompanionBuilder,
      (
        ClipboardItemEntry,
        BaseReferences<
          _$ClipboardDatabase,
          $ClipboardItemEntriesTable,
          ClipboardItemEntry
        >,
      ),
      ClipboardItemEntry,
      PrefetchHooks Function()
    >;
typedef $$ClipboardOutboxEntriesTableCreateCompanionBuilder =
    ClipboardOutboxEntriesCompanion Function({
      required String operationId,
      required String entityId,
      required String userId,
      required String operationType,
      Value<String?> payload,
      required String deviceId,
      Value<String> status,
      Value<DateTime?> sentAt,
      Value<int> retryCount,
      Value<String?> lastError,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ClipboardOutboxEntriesTableUpdateCompanionBuilder =
    ClipboardOutboxEntriesCompanion Function({
      Value<String> operationId,
      Value<String> entityId,
      Value<String> userId,
      Value<String> operationType,
      Value<String?> payload,
      Value<String> deviceId,
      Value<String> status,
      Value<DateTime?> sentAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ClipboardOutboxEntriesTableFilterComposer
    extends Composer<_$ClipboardDatabase, $ClipboardOutboxEntriesTable> {
  $$ClipboardOutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClipboardOutboxEntriesTableOrderingComposer
    extends Composer<_$ClipboardDatabase, $ClipboardOutboxEntriesTable> {
  $$ClipboardOutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClipboardOutboxEntriesTableAnnotationComposer
    extends Composer<_$ClipboardDatabase, $ClipboardOutboxEntriesTable> {
  $$ClipboardOutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ClipboardOutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$ClipboardDatabase,
          $ClipboardOutboxEntriesTable,
          ClipboardOutboxEntry,
          $$ClipboardOutboxEntriesTableFilterComposer,
          $$ClipboardOutboxEntriesTableOrderingComposer,
          $$ClipboardOutboxEntriesTableAnnotationComposer,
          $$ClipboardOutboxEntriesTableCreateCompanionBuilder,
          $$ClipboardOutboxEntriesTableUpdateCompanionBuilder,
          (
            ClipboardOutboxEntry,
            BaseReferences<
              _$ClipboardDatabase,
              $ClipboardOutboxEntriesTable,
              ClipboardOutboxEntry
            >,
          ),
          ClipboardOutboxEntry,
          PrefetchHooks Function()
        > {
  $$ClipboardOutboxEntriesTableTableManager(
    _$ClipboardDatabase db,
    $ClipboardOutboxEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClipboardOutboxEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ClipboardOutboxEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClipboardOutboxEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardOutboxEntriesCompanion(
                operationId: operationId,
                entityId: entityId,
                userId: userId,
                operationType: operationType,
                payload: payload,
                deviceId: deviceId,
                status: status,
                sentAt: sentAt,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String entityId,
                required String userId,
                required String operationType,
                Value<String?> payload = const Value.absent(),
                required String deviceId,
                Value<String> status = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ClipboardOutboxEntriesCompanion.insert(
                operationId: operationId,
                entityId: entityId,
                userId: userId,
                operationType: operationType,
                payload: payload,
                deviceId: deviceId,
                status: status,
                sentAt: sentAt,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClipboardOutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ClipboardDatabase,
      $ClipboardOutboxEntriesTable,
      ClipboardOutboxEntry,
      $$ClipboardOutboxEntriesTableFilterComposer,
      $$ClipboardOutboxEntriesTableOrderingComposer,
      $$ClipboardOutboxEntriesTableAnnotationComposer,
      $$ClipboardOutboxEntriesTableCreateCompanionBuilder,
      $$ClipboardOutboxEntriesTableUpdateCompanionBuilder,
      (
        ClipboardOutboxEntry,
        BaseReferences<
          _$ClipboardDatabase,
          $ClipboardOutboxEntriesTable,
          ClipboardOutboxEntry
        >,
      ),
      ClipboardOutboxEntry,
      PrefetchHooks Function()
    >;

class $ClipboardDatabaseManager {
  final _$ClipboardDatabase _db;

  $ClipboardDatabaseManager(this._db);

  $$ClipboardItemEntriesTableTableManager get clipboardItemEntries =>
      $$ClipboardItemEntriesTableTableManager(_db, _db.clipboardItemEntries);

  $$ClipboardOutboxEntriesTableTableManager get clipboardOutboxEntries =>
      $$ClipboardOutboxEntriesTableTableManager(
        _db,
        _db.clipboardOutboxEntries,
      );
}

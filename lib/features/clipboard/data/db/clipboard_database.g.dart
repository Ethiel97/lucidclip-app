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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
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
    type,
    createdAt,
    updatedAt,
    htmlContent,
    imageBytes,
    filePath,
    isPinned,
    isSnippet,
    isSynced,
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
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
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
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
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
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? htmlContent;
  final String? imageBytes;
  final String? filePath;
  final bool isPinned;
  final bool isSnippet;
  final bool isSynced;
  final String? metadataJson;
  const ClipboardItemEntry({
    required this.id,
    required this.content,
    required this.contentHash,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.htmlContent,
    this.imageBytes,
    this.filePath,
    required this.isPinned,
    required this.isSnippet,
    required this.isSynced,
    this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['content_hash'] = Variable<String>(contentHash);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
    map['is_synced'] = Variable<bool>(isSynced);
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
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      isSynced: Value(isSynced),
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
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      htmlContent: serializer.fromJson<String?>(json['htmlContent']),
      imageBytes: serializer.fromJson<String?>(json['imageBytes']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isSnippet: serializer.fromJson<bool>(json['isSnippet']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
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
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'htmlContent': serializer.toJson<String?>(htmlContent),
      'imageBytes': serializer.toJson<String?>(imageBytes),
      'filePath': serializer.toJson<String?>(filePath),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isSnippet': serializer.toJson<bool>(isSnippet),
      'isSynced': serializer.toJson<bool>(isSynced),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  ClipboardItemEntry copyWith({
    String? id,
    String? content,
    String? contentHash,
    String? userId,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> htmlContent = const Value.absent(),
    Value<String?> imageBytes = const Value.absent(),
    Value<String?> filePath = const Value.absent(),
    bool? isPinned,
    bool? isSnippet,
    bool? isSynced,
    Value<String?> metadataJson = const Value.absent(),
  }) => ClipboardItemEntry(
    id: id ?? this.id,
    content: content ?? this.content,
    contentHash: contentHash ?? this.contentHash,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    htmlContent: htmlContent.present ? htmlContent.value : this.htmlContent,
    imageBytes: imageBytes.present ? imageBytes.value : this.imageBytes,
    filePath: filePath.present ? filePath.value : this.filePath,
    isPinned: isPinned ?? this.isPinned,
    isSnippet: isSnippet ?? this.isSnippet,
    isSynced: isSynced ?? this.isSynced,
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
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      htmlContent: data.htmlContent.present
          ? data.htmlContent.value
          : this.htmlContent,
      imageBytes: data.imageBytes.present
          ? data.imageBytes.value
          : this.imageBytes,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isSnippet: data.isSnippet.present ? data.isSnippet.value : this.isSnippet,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
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
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('filePath: $filePath, ')
          ..write('isPinned: $isPinned, ')
          ..write('isSnippet: $isSnippet, ')
          ..write('isSynced: $isSynced, ')
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
    type,
    createdAt,
    updatedAt,
    htmlContent,
    imageBytes,
    filePath,
    isPinned,
    isSnippet,
    isSynced,
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
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.htmlContent == this.htmlContent &&
          other.imageBytes == this.imageBytes &&
          other.filePath == this.filePath &&
          other.isPinned == this.isPinned &&
          other.isSnippet == this.isSnippet &&
          other.isSynced == this.isSynced &&
          other.metadataJson == this.metadataJson);
}

class ClipboardItemEntriesCompanion
    extends UpdateCompanion<ClipboardItemEntry> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> contentHash;
  final Value<String> userId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> htmlContent;
  final Value<String?> imageBytes;
  final Value<String?> filePath;
  final Value<bool> isPinned;
  final Value<bool> isSnippet;
  final Value<bool> isSynced;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const ClipboardItemEntriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isSnippet = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClipboardItemEntriesCompanion.insert({
    required String id,
    required String content,
    required String contentHash,
    required String userId,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.htmlContent = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isSnippet = const Value.absent(),
    this.isSynced = const Value.absent(),
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
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? htmlContent,
    Expression<String>? imageBytes,
    Expression<String>? filePath,
    Expression<bool>? isPinned,
    Expression<bool>? isSnippet,
    Expression<bool>? isSynced,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (contentHash != null) 'content_hash': contentHash,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (htmlContent != null) 'html_content': htmlContent,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (filePath != null) 'file_path': filePath,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isSnippet != null) 'is_snippet': isSnippet,
      if (isSynced != null) 'is_synced': isSynced,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClipboardItemEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? contentHash,
    Value<String>? userId,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? htmlContent,
    Value<String?>? imageBytes,
    Value<String?>? filePath,
    Value<bool>? isPinned,
    Value<bool>? isSnippet,
    Value<bool>? isSynced,
    Value<String?>? metadataJson,
    Value<int>? rowid,
  }) {
    return ClipboardItemEntriesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      contentHash: contentHash ?? this.contentHash,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      htmlContent: htmlContent ?? this.htmlContent,
      imageBytes: imageBytes ?? this.imageBytes,
      filePath: filePath ?? this.filePath,
      isPinned: isPinned ?? this.isPinned,
      isSnippet: isSnippet ?? this.isSnippet,
      isSynced: isSynced ?? this.isSynced,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
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
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('filePath: $filePath, ')
          ..write('isPinned: $isPinned, ')
          ..write('isSnippet: $isSnippet, ')
          ..write('isSynced: $isSynced, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClipboardHistoryEntriesTable extends ClipboardHistoryEntries
    with TableInfo<$ClipboardHistoryEntriesTable, ClipboardHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClipboardHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clipboardItemIdMeta = const VerificationMeta(
    'clipboardItemId',
  );
  @override
  late final GeneratedColumn<String> clipboardItemId = GeneratedColumn<String>(
    'clipboard_item_id',
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
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clipboardItemId,
    userId,
    action,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clipboard_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClipboardHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('clipboard_item_id')) {
      context.handle(
        _clipboardItemIdMeta,
        clipboardItemId.isAcceptableOrUnknown(
          data['clipboard_item_id']!,
          _clipboardItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clipboardItemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClipboardHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClipboardHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clipboardItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clipboard_item_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
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
  $ClipboardHistoryEntriesTable createAlias(String alias) {
    return $ClipboardHistoryEntriesTable(attachedDatabase, alias);
  }
}

class ClipboardHistoryEntry extends DataClass
    implements Insertable<ClipboardHistoryEntry> {
  final String id;
  final String clipboardItemId;
  final String userId;
  final String action;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ClipboardHistoryEntry({
    required this.id,
    required this.clipboardItemId,
    required this.userId,
    required this.action,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['clipboard_item_id'] = Variable<String>(clipboardItemId);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClipboardHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return ClipboardHistoryEntriesCompanion(
      id: Value(id),
      clipboardItemId: Value(clipboardItemId),
      userId: Value(userId),
      action: Value(action),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ClipboardHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClipboardHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      clipboardItemId: serializer.fromJson<String>(json['clipboardItemId']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clipboardItemId': serializer.toJson<String>(clipboardItemId),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ClipboardHistoryEntry copyWith({
    String? id,
    String? clipboardItemId,
    String? userId,
    String? action,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ClipboardHistoryEntry(
    id: id ?? this.id,
    clipboardItemId: clipboardItemId ?? this.clipboardItemId,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ClipboardHistoryEntry copyWithCompanion(
    ClipboardHistoryEntriesCompanion data,
  ) {
    return ClipboardHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      clipboardItemId: data.clipboardItemId.present
          ? data.clipboardItemId.value
          : this.clipboardItemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClipboardHistoryEntry(')
          ..write('id: $id, ')
          ..write('clipboardItemId: $clipboardItemId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clipboardItemId, userId, action, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClipboardHistoryEntry &&
          other.id == this.id &&
          other.clipboardItemId == this.clipboardItemId &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClipboardHistoryEntriesCompanion
    extends UpdateCompanion<ClipboardHistoryEntry> {
  final Value<String> id;
  final Value<String> clipboardItemId;
  final Value<String> userId;
  final Value<String> action;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClipboardHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.clipboardItemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClipboardHistoryEntriesCompanion.insert({
    required String id,
    required String clipboardItemId,
    required String userId,
    required String action,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clipboardItemId = Value(clipboardItemId),
       userId = Value(userId),
       action = Value(action),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ClipboardHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? clipboardItemId,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clipboardItemId != null) 'clipboard_item_id': clipboardItemId,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClipboardHistoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? clipboardItemId,
    Value<String>? userId,
    Value<String>? action,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClipboardHistoryEntriesCompanion(
      id: id ?? this.id,
      clipboardItemId: clipboardItemId ?? this.clipboardItemId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clipboardItemId.present) {
      map['clipboard_item_id'] = Variable<String>(clipboardItemId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
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
    return (StringBuffer('ClipboardHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('clipboardItemId: $clipboardItemId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $ClipboardHistoryEntriesTable clipboardHistoryEntries =
      $ClipboardHistoryEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clipboardItemEntries,
    clipboardHistoryEntries,
  ];
}

typedef $$ClipboardItemEntriesTableCreateCompanionBuilder =
    ClipboardItemEntriesCompanion Function({
      required String id,
      required String content,
      required String contentHash,
      required String userId,
      required String type,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> htmlContent,
      Value<String?> imageBytes,
      Value<String?> filePath,
      Value<bool> isPinned,
      Value<bool> isSnippet,
      Value<bool> isSynced,
      Value<String?> metadataJson,
      Value<int> rowid,
    });
typedef $$ClipboardItemEntriesTableUpdateCompanionBuilder =
    ClipboardItemEntriesCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> contentHash,
      Value<String> userId,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> htmlContent,
      Value<String?> imageBytes,
      Value<String?> filePath,
      Value<bool> isPinned,
      Value<bool> isSnippet,
      Value<bool> isSynced,
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

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
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

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

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
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> imageBytes = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isSnippet = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardItemEntriesCompanion(
                id: id,
                content: content,
                contentHash: contentHash,
                userId: userId,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                htmlContent: htmlContent,
                imageBytes: imageBytes,
                filePath: filePath,
                isPinned: isPinned,
                isSnippet: isSnippet,
                isSynced: isSynced,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required String contentHash,
                required String userId,
                required String type,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> htmlContent = const Value.absent(),
                Value<String?> imageBytes = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isSnippet = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardItemEntriesCompanion.insert(
                id: id,
                content: content,
                contentHash: contentHash,
                userId: userId,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                htmlContent: htmlContent,
                imageBytes: imageBytes,
                filePath: filePath,
                isPinned: isPinned,
                isSnippet: isSnippet,
                isSynced: isSynced,
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
typedef $$ClipboardHistoryEntriesTableCreateCompanionBuilder =
    ClipboardHistoryEntriesCompanion Function({
      required String id,
      required String clipboardItemId,
      required String userId,
      required String action,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ClipboardHistoryEntriesTableUpdateCompanionBuilder =
    ClipboardHistoryEntriesCompanion Function({
      Value<String> id,
      Value<String> clipboardItemId,
      Value<String> userId,
      Value<String> action,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ClipboardHistoryEntriesTableFilterComposer
    extends Composer<_$ClipboardDatabase, $ClipboardHistoryEntriesTable> {
  $$ClipboardHistoryEntriesTableFilterComposer({
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

  ColumnFilters<String> get clipboardItemId => $composableBuilder(
    column: $table.clipboardItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
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

class $$ClipboardHistoryEntriesTableOrderingComposer
    extends Composer<_$ClipboardDatabase, $ClipboardHistoryEntriesTable> {
  $$ClipboardHistoryEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get clipboardItemId => $composableBuilder(
    column: $table.clipboardItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
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

class $$ClipboardHistoryEntriesTableAnnotationComposer
    extends Composer<_$ClipboardDatabase, $ClipboardHistoryEntriesTable> {
  $$ClipboardHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clipboardItemId => $composableBuilder(
    column: $table.clipboardItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClipboardHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$ClipboardDatabase,
          $ClipboardHistoryEntriesTable,
          ClipboardHistoryEntry,
          $$ClipboardHistoryEntriesTableFilterComposer,
          $$ClipboardHistoryEntriesTableOrderingComposer,
          $$ClipboardHistoryEntriesTableAnnotationComposer,
          $$ClipboardHistoryEntriesTableCreateCompanionBuilder,
          $$ClipboardHistoryEntriesTableUpdateCompanionBuilder,
          (
            ClipboardHistoryEntry,
            BaseReferences<
              _$ClipboardDatabase,
              $ClipboardHistoryEntriesTable,
              ClipboardHistoryEntry
            >,
          ),
          ClipboardHistoryEntry,
          PrefetchHooks Function()
        > {
  $$ClipboardHistoryEntriesTableTableManager(
    _$ClipboardDatabase db,
    $ClipboardHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClipboardHistoryEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ClipboardHistoryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ClipboardHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clipboardItemId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClipboardHistoryEntriesCompanion(
                id: id,
                clipboardItemId: clipboardItemId,
                userId: userId,
                action: action,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clipboardItemId,
                required String userId,
                required String action,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ClipboardHistoryEntriesCompanion.insert(
                id: id,
                clipboardItemId: clipboardItemId,
                userId: userId,
                action: action,
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

typedef $$ClipboardHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ClipboardDatabase,
      $ClipboardHistoryEntriesTable,
      ClipboardHistoryEntry,
      $$ClipboardHistoryEntriesTableFilterComposer,
      $$ClipboardHistoryEntriesTableOrderingComposer,
      $$ClipboardHistoryEntriesTableAnnotationComposer,
      $$ClipboardHistoryEntriesTableCreateCompanionBuilder,
      $$ClipboardHistoryEntriesTableUpdateCompanionBuilder,
      (
        ClipboardHistoryEntry,
        BaseReferences<
          _$ClipboardDatabase,
          $ClipboardHistoryEntriesTable,
          ClipboardHistoryEntry
        >,
      ),
      ClipboardHistoryEntry,
      PrefetchHooks Function()
    >;

class $ClipboardDatabaseManager {
  final _$ClipboardDatabase _db;
  $ClipboardDatabaseManager(this._db);
  $$ClipboardItemEntriesTableTableManager get clipboardItemEntries =>
      $$ClipboardItemEntriesTableTableManager(_db, _db.clipboardItemEntries);
  $$ClipboardHistoryEntriesTableTableManager get clipboardHistoryEntries =>
      $$ClipboardHistoryEntriesTableTableManager(
        _db,
        _db.clipboardHistoryEntries,
      );
}

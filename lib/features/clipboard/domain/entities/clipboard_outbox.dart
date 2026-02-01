typedef ClipboardOutboxes = List<ClipboardOutbox>;

class ClipboardOutbox {
  ClipboardOutbox({
    required this.entityId,
    required this.createdAt,
    required this.deviceId,
    required this.id,
    required this.userId,
    this.lastError,
    this.operationType = ClipboardOperationType.unknown,
    this.payload,
    this.retryCount = 0,
    this.sentAt,
    this.status = ClipboardOutboxStatus.unknown,
  });

  final ClipboardOperationType operationType;

  /// Corresponds to the outbox `entity_id`.
  ///
  /// For clipboard operations this points to the clipboard item id.
  final String entityId;

  final DateTime createdAt;

  /// Corresponds to the outbox `device_id`.
  final String deviceId;

  final String id;

  final String userId;

  /// Optional last error returned while trying to send this outbox item.
  final String? lastError;

  /// Optional payload associated with the operation.
  final Map<String, dynamic>? payload;

  /// Number of retry attempts.
  final int retryCount;

  /// Timestamp when the outbox item was successfully sent.
  final DateTime? sentAt;

  final ClipboardOutboxStatus status;

  ClipboardOutbox copyWith({
    ClipboardOperationType? operationType,
    String? entityId,
    DateTime? createdAt,
    String? deviceId,
    String? id,
    String? userId,
    String? lastError,
    Map<String, dynamic>? payload,
    int? retryCount,
    DateTime? sentAt,
    ClipboardOutboxStatus? status,
  }) {
    return ClipboardOutbox(
      operationType: operationType ?? this.operationType,
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lastError: lastError ?? this.lastError,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
    );
  }

  /// Convenience map for lightweight serialization/logging.
  ///
  /// Note: this is not used for JSON serialization;
  /// the model layer handles that.
  Map<String, dynamic> toMap() {
    return {
      'operationType': operationType.name,
      'entityId': entityId,
      'createdAt': createdAt.toIso8601String(),
      'deviceId': deviceId,
      'id': id,
      'lastError': lastError,
      'payload': payload,
      'retryCount': retryCount,
      'sentAt': sentAt?.toIso8601String(),
      'status': status.name,
      'userId': userId,
    };
  }
}

enum ClipboardOperationType {
  insert,
  update,
  delete,
  pin,
  unknown,
  unpin;

  bool get isInsert => this == ClipboardOperationType.insert;

  bool get isUpdate => this == ClipboardOperationType.update;

  bool get isDelete => this == ClipboardOperationType.delete;

  bool get isPin => this == ClipboardOperationType.pin;

  bool get isUnpin => this == ClipboardOperationType.unpin;

  bool get isUnknown => this == ClipboardOperationType.unknown;
}

enum ClipboardOutboxStatus {
  pending,
  sent,
  failed,
  conflict,
  unknown;

  bool get isPending => this == ClipboardOutboxStatus.pending;

  bool get isConflict => this == ClipboardOutboxStatus.conflict;

  bool get isSent => this == ClipboardOutboxStatus.sent;

  bool get isFailed => this == ClipboardOutboxStatus.failed;

  bool get isUnknown => this == ClipboardOutboxStatus.unknown;
}

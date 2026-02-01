import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_outbox_model.g.dart';

typedef ClipboardHistoryModels = List<ClipboardOutboxModel>;

@JsonSerializable(explicitToJson: true)
class ClipboardOutboxModel extends Equatable {
  const ClipboardOutboxModel({
    required this.operationType,
    required this.entityId,
    required this.createdAt,
    required this.deviceId,
    required this.id,
    required this.userId,
    this.retryCount = 0,
    this.status = ClipboardOutboxStatusModel.pending,
    this.lastError,
    this.payload,
    this.sentAt,
  });

  factory ClipboardOutboxModel.fromEntity(ClipboardOutbox entity) {
    ClipboardOperationTypeModel? operationTypeModel;
    operationTypeModel = ClipboardOperationTypeModel.values.firstWhere(
      (model) => model.name == entity.operationType.name,
    );

    return ClipboardOutboxModel(
      operationType: operationTypeModel,
      entityId: entity.entityId,
      createdAt: entity.createdAt,
      deviceId: entity.deviceId,
      id: entity.id,
      lastError: entity.lastError,
      payload: entity.payload,
      retryCount: entity.retryCount,
      sentAt: entity.sentAt,
      userId: entity.userId,
    );
  }

  factory ClipboardOutboxModel.fromJson(Map<String, dynamic> json) =>
      _$ClipboardOutboxModelFromJson(json);

  @JsonKey(name: 'entity_id')
  final String entityId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'device_id')
  final String deviceId;

  final String id;

  @JsonKey(
    name: 'operation_type',
    defaultValue: ClipboardOperationTypeModel.insert,
    unknownEnumValue: ClipboardOperationTypeModel.unknown,
  )
  final ClipboardOperationTypeModel operationType;

  @JsonKey(name: 'last_error')
  final String? lastError;

  final Map<String, dynamic>? payload;

  @JsonKey(name: 'retry_count')
  final int retryCount;

  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;

  @JsonKey(
    defaultValue: ClipboardOutboxStatusModel.pending,
    unknownEnumValue: ClipboardOutboxStatusModel.unknown,
  )
  final ClipboardOutboxStatusModel status;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$ClipboardOutboxModelToJson(this);

  ClipboardOutboxModel copyWith({
    ClipboardOperationTypeModel? operationType,
    DateTime? createdAt,
    String? deviceId,
    String? entityId,
    String? id,
    String? lastError,
    Map<String, dynamic>? payload,
    int? retryCount,
    DateTime? sentAt,
    String? userId,
  }) {
    return ClipboardOutboxModel(
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      id: id ?? this.id,
      lastError: lastError ?? this.lastError,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      sentAt: sentAt ?? this.sentAt,
      userId: userId ?? this.userId,
    );
  }

  ClipboardOutbox toEntity() {
    ClipboardOperationType? operationType;
    operationType = ClipboardOperationType.values.firstWhere(
      (entity) => entity.name == this.operationType.name,
    );

    ClipboardOutboxStatus? status;
    status = ClipboardOutboxStatus.values.firstWhere(
      (entity) => entity.name == this.status.name,
    );

    return ClipboardOutbox(
      operationType: operationType,
      deviceId: deviceId,
      entityId: entityId,
      createdAt: createdAt,
      id: id,
      lastError: lastError,
      payload: payload,
      retryCount: retryCount,
      sentAt: sentAt,
      status: status,
      userId: userId,
    );
  }

  @override
  List<Object?> get props => [
    entityId,
    createdAt,
    deviceId,
    id,
    lastError,
    operationType,
    payload,
    retryCount,
    sentAt,
    status,
    userId,
  ];
}

enum ClipboardOperationTypeModel {
  insert,
  update,
  delete,
  pin,
  unknown,
  unpin;

  bool get isInsert => this == ClipboardOperationTypeModel.insert;

  bool get isUpdate => this == ClipboardOperationTypeModel.update;

  bool get isDelete => this == ClipboardOperationTypeModel.delete;

  bool get isPin => this == ClipboardOperationTypeModel.pin;

  bool get isUnpin => this == ClipboardOperationTypeModel.unpin;

  bool get isUnknown => this == ClipboardOperationTypeModel.unknown;
}

enum ClipboardOutboxStatusModel {
  pending,
  sent,
  failed,
  conflict,
  unknown;

  bool get isConflict => this == ClipboardOutboxStatusModel.conflict;

  bool get isPending => this == ClipboardOutboxStatusModel.pending;

  bool get isSent => this == ClipboardOutboxStatusModel.sent;

  bool get isFailed => this == ClipboardOutboxStatusModel.failed;

  bool get isUnknown => this == ClipboardOutboxStatusModel.unknown;
}

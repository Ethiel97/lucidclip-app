// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_outbox_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClipboardOutboxModel _$ClipboardOutboxModelFromJson(
  Map<String, dynamic> json,
) => ClipboardOutboxModel(
  operationType:
      $enumDecodeNullable(
        _$ClipboardOperationTypeModelEnumMap,
        json['operation_type'],
        unknownValue: ClipboardOperationTypeModel.unknown,
      ) ??
      ClipboardOperationTypeModel.insert,
  entityId: json['entity_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  deviceId: json['device_id'] as String,
  id: json['id'] as String,
  userId: json['user_id'] as String,
  retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(
        _$ClipboardOutboxStatusModelEnumMap,
        json['status'],
        unknownValue: ClipboardOutboxStatusModel.unknown,
      ) ??
      ClipboardOutboxStatusModel.pending,
  lastError: json['last_error'] as String?,
  payload: json['payload'] as Map<String, dynamic>?,
  sentAt: json['sent_at'] == null
      ? null
      : DateTime.parse(json['sent_at'] as String),
);

Map<String, dynamic> _$ClipboardOutboxModelToJson(
  ClipboardOutboxModel instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'created_at': instance.createdAt.toIso8601String(),
  'device_id': instance.deviceId,
  'id': instance.id,
  'operation_type':
      _$ClipboardOperationTypeModelEnumMap[instance.operationType]!,
  'last_error': instance.lastError,
  'payload': instance.payload,
  'retry_count': instance.retryCount,
  'sent_at': instance.sentAt?.toIso8601String(),
  'status': _$ClipboardOutboxStatusModelEnumMap[instance.status]!,
  'user_id': instance.userId,
};

const _$ClipboardOperationTypeModelEnumMap = {
  ClipboardOperationTypeModel.insert: 'insert',
  ClipboardOperationTypeModel.update: 'update',
  ClipboardOperationTypeModel.delete: 'delete',
  ClipboardOperationTypeModel.pin: 'pin',
  ClipboardOperationTypeModel.unknown: 'unknown',
  ClipboardOperationTypeModel.unpin: 'unpin',
};

const _$ClipboardOutboxStatusModelEnumMap = {
  ClipboardOutboxStatusModel.pending: 'pending',
  ClipboardOutboxStatusModel.sent: 'sent',
  ClipboardOutboxStatusModel.failed: 'failed',
  ClipboardOutboxStatusModel.conflict: 'conflict',
  ClipboardOutboxStatusModel.unknown: 'unknown',
};

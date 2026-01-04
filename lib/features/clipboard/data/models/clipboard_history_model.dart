import 'dart:developer' as developer;

import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_history_model.g.dart';

typedef ClipboardHistoryModels = List<ClipboardHistoryModel>;

@JsonSerializable(explicitToJson: true)
class ClipboardHistoryModel {
  ClipboardHistoryModel({
    required this.action,
    required this.clipboardItemId,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.userId,
  });

  factory ClipboardHistoryModel.fromEntity(ClipboardHistory entity) {
    ClipboardActionModel? actionModel;
    try {
      actionModel = ClipboardActionModel.values.firstWhere(
        (model) => model.name == entity.action.name,
      );
    } catch (e) {
      developer.log(
        'Enum mismatch: ClipboardAction.${entity.action.name} not found '
        'in ClipboardActionModel. Using copy as fallback.',
        name: 'ClipboardHistoryModel',
        level: 900, // WARNING: 900 is standard warning level in dart:developer
      );
      actionModel = ClipboardActionModel.copy;
    }

    return ClipboardHistoryModel(
      action: actionModel,
      clipboardItemId: entity.clipboardItemId,
      createdAt: entity.createdAt,
      id: entity.id,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
    );
  }

  factory ClipboardHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ClipboardHistoryModelFromJson(json);

  @JsonKey(
    defaultValue: ClipboardActionModel.copy,
    unknownEnumValue: ClipboardActionModel.copy,
  )
  final ClipboardActionModel action;

  @JsonKey(name: 'clipboard_item_id')
  final String clipboardItemId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final String id;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$ClipboardHistoryModelToJson(this);

  ClipboardHistoryModel copyWith({
    ClipboardActionModel? action,
    String? clipboardItemId,
    DateTime? createdAt,
    String? id,
    DateTime? updatedAt,
    String? userId,
  }) {
    return ClipboardHistoryModel(
      action: action ?? this.action,
      clipboardItemId: clipboardItemId ?? this.clipboardItemId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  ClipboardHistory toEntity() {
    ClipboardAction? actionEntity;
    try {
      actionEntity = ClipboardAction.values.firstWhere(
        (entity) => entity.name == action.name,
      );
    } catch (e) {
      developer.log(
        'Enum mismatch: ClipboardActionModel.${action.name} not found in'
        ' ClipboardAction. Using copy as fallback.',
        name: 'ClipboardHistoryModel',
        level: 900, // WARNING: 900 is standard warning level in dart:developer
      );
      actionEntity = ClipboardAction.copy;
    }

    return ClipboardHistory(
      action: actionEntity,
      clipboardItemId: clipboardItemId,
      createdAt: createdAt,
      id: id,
      updatedAt: updatedAt,
      userId: userId,
    );
  }
}

enum ClipboardActionModel {
  copy,
  paste,
  delete,
  edit,
  pin,
  unpin;

  bool get isCopy => this == ClipboardActionModel.copy;

  bool get isPaste => this == ClipboardActionModel.paste;

  bool get isDelete => this == ClipboardActionModel.delete;

  bool get isEdit => this == ClipboardActionModel.edit;

  bool get isPin => this == ClipboardActionModel.pin;

  bool get isUnpin => this == ClipboardActionModel.unpin;
}

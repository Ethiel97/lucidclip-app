import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_history_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class ClipboardHistoryModel {
  ClipboardHistoryModel({
    required this.action,
    required this.clipboardItemId,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.userId,
  });

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
    return ClipboardHistory(
      action: ClipboardAction.values[action.index],
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
  edit;

  bool get isCopy => this == ClipboardActionModel.copy;

  bool get isPaste => this == ClipboardActionModel.paste;

  bool get isDelete => this == ClipboardActionModel.delete;

  bool get isEdit => this == ClipboardActionModel.edit;
}

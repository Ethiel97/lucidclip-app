import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_item_tag_model.g.dart';

typedef ClipboardItemTagModels = List<ClipboardItemTagModel>;

@JsonSerializable(
  explicitToJson: true,
)
class ClipboardItemTagModel {
  ClipboardItemTagModel({
    required this.clipboardItemId,
    required this.createdAt,
    required this.tagId,
    required this.updatedAt,
  });

  factory ClipboardItemTagModel.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemTagModelFromJson(json);

  @JsonKey(name: 'clipboard_item_id')
  final String clipboardItemId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'tag_id')
  final String tagId;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ClipboardItemTagModelToJson(this);

  ClipboardItemTagModel copyWith({
    String? clipboardItemId,
    DateTime? createdAt,
    String? tagId,
    DateTime? updatedAt,
  }) {
    return ClipboardItemTagModel(
      clipboardItemId: clipboardItemId ?? this.clipboardItemId,
      createdAt: createdAt ?? this.createdAt,
      tagId: tagId ?? this.tagId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ClipboardItemTag toEntity() {
    return ClipboardItemTag(
      clipboardItemId: clipboardItemId,
      createdAt: createdAt,
      tagId: tagId,
      updatedAt: updatedAt,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'tag_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class TagModel {
  TagModel({
    required this.color,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.userId,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  final String color;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final String id;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;

  final String name;

  Map<String, dynamic> toJson() => _$TagModelToJson(this);

  TagModel copyWith({
    String? color,
    DateTime? createdAt,
    String? id,
    String? name,
    DateTime? updatedAt,
    String? userId,
  }) {
    return TagModel(
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  Tag toEntity() {
    return Tag(
      color: color,
      createdAt: createdAt,
      id: id,
      name: name,
      updatedAt: updatedAt,
      userId: userId,
    );
  }
}

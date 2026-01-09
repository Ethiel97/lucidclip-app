import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';

part 'source_app_model.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, String?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(String? json) {
    if (json == null) return null;
    return base64Decode(json);
  }

  @override
  String? toJson(Uint8List? object) {
    if (object == null) return null;
    return base64Encode(object);
  }
}

@JsonSerializable(explicitToJson: true)
class SourceAppModel extends Equatable {
  const SourceAppModel({required this.bundleId, required this.name, this.icon});

  factory SourceAppModel.fromEntity(SourceApp entity) {
    return SourceAppModel(
      bundleId: entity.bundleId,
      name: entity.name,
      icon: entity.icon,
    );
  }

  factory SourceAppModel.fromJson(Map<String, dynamic> json) =>
      _$SourceAppModelFromJson(json);

  @JsonKey(name: 'bundle_id')
  final String bundleId;

  @JsonKey(name: 'name')
  final String name;

  @Uint8ListConverter()
  @JsonKey(name: 'icon')
  final Uint8List? icon;

  bool get isValid => bundleId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => _$SourceAppModelToJson(this);

  SourceApp toEntity() {
    return SourceApp(bundleId: bundleId, name: name, icon: icon);
  }

  @override
  List<Object?> get props => [bundleId, name, icon];
}

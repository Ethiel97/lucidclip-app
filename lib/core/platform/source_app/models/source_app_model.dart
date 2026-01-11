import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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

  factory SourceAppModel.fromJsonWithIcon(Map<String, dynamic> json) {
    final bundleId = json['bundle_id'] as String;
    final name = json['name'] as String;

    Uint8List? icon;
    if (json['icon'] != null) {
      icon = base64Decode(json['icon'] as String);
    }

    return SourceAppModel(bundleId: bundleId, name: name, icon: icon);
  }

  @JsonKey(name: 'bundle_id')
  final String bundleId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Uint8List? icon;

  bool get isValid => bundleId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => _$SourceAppModelToJson(this);

  Map<String, dynamic> toJsonWithIcon() {
    final json = toJson();
    if (icon != null) {
      json['icon'] = base64Encode(icon!);
    }
    return json;
  }

  SourceApp toEntity() {
    return SourceApp(bundleId: bundleId, name: name, icon: icon);
  }

  SourceAppModel copyWith({String? bundleId, String? name, Uint8List? icon}) {
    return SourceAppModel(
      bundleId: bundleId ?? this.bundleId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [bundleId, name, icon];
}

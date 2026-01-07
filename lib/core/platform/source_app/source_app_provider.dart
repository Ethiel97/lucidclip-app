import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SourceApp extends Equatable {
  const SourceApp({required this.bundleId, required this.name, this.icon});

  factory SourceApp.fromMap(Map<dynamic, dynamic> map) {
    final b64 = map['icon'] as String?;
    return SourceApp(
      bundleId: (map['bundleId'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      icon: b64 == null ? null : base64Decode(b64),
    );
  }

  final String bundleId;
  final String name;

  final Uint8List? icon;

  bool get isValid => bundleId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
    'bundleId': bundleId,
    'name': name,
    'icon': icon != null ? base64Encode(icon!) : null,
  };

  @override
  List<Object?> get props => [bundleId, name];
}

//ignore: one_member_abstracts
abstract class SourceAppProvider {
  Future<SourceApp?> getFrontmostApp();
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SourceApp extends Equatable {
  const SourceApp({required this.bundleId, required this.name, this.iconBytes});

  factory SourceApp.fromMap(Map<dynamic, dynamic> map) {
    final b64 = map['iconPngBase64'] as String?;
    return SourceApp(
      bundleId: (map['bundleId'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      iconBytes: b64 == null ? null : base64Decode(b64),
    );
  }

  final String bundleId;
  final String name;

  final Uint8List? iconBytes;

  bool get isValid => bundleId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {'bundleId': bundleId, 'name': name};

  @override
  List<Object?> get props => [bundleId, name];
}

abstract class SourceAppProvider {
  Future<SourceApp?> getFrontmostApp();
}

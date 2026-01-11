import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SourceApp extends Equatable {
  const SourceApp({required this.bundleId, required this.name, this.icon});

  final String bundleId;

  final String name;

  final Uint8List? icon;

  bool get isValid => bundleId.trim().isNotEmpty;

  SourceApp copyWith({String? bundleId, String? name, Uint8List? icon}) {
    return SourceApp(
      bundleId: bundleId ?? this.bundleId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [bundleId, name, icon];
}

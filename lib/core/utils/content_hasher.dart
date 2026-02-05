// dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class ContentHasher {
  const ContentHasher._();

  static String hashBytes(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String hashString(String input) =>
      hashBytes(utf8.encode(_normalizeString(input)));

  static String hashJson(Map<String, dynamic> json) {
    final stable = _stableJson(json);
    return hashString(stable);
  }

  static String hashOfParts(Iterable<Object?> parts) {
    final buffer = StringBuffer();
    for (final p in parts) {
      if (p == null) {
        buffer.write('<null>|');
      } else if (p is List<int> || p is Uint8List) {
        buffer
          ..write(base64.encode(p is List<int> ? p : (p as Uint8List).toList()))
          ..write('|');
      } else if (p is Map<String, dynamic>) {
        buffer
          ..write(_stableJson(p))
          ..write('|');
      } else {
        buffer
          ..write(_normalizeString(p.toString()))
          ..write('|');
      }
    }
    return hashString(buffer.toString());
  }

  // --- Helpers ---

  static String _normalizeString(String s) {
    return s.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Retourne une json string stable avec clés triées (récursif).
  static String _stableJson(Map<String, dynamic> map) {
    final entries = map.keys.toList()..sort();
    final buffer = StringBuffer()..write('{');
    var first = true;
    for (final k in entries) {
      if (!first) buffer.write(',');
      first = false;
      buffer
        ..write(jsonEncode(k))
        ..write(':')
        ..write(_valueToStableJson(map[k]));
    }
    buffer.write('}');
    return buffer.toString();
  }

  static String _valueToStableJson(Object? v) {
    if (v == null) return 'null';
    if (v is Map<String, dynamic>) return _stableJson(v);
    if (v is List) {
      final items = v.map(_valueToStableJson).join(',');
      return '[$items]';
    }
    if (v is String) return jsonEncode(_normalizeString(v));
    if (v is num || v is bool) return jsonEncode(v);
    // Fallback : encodage string normalisé
    return jsonEncode(_normalizeString(v.toString()));
  }
}

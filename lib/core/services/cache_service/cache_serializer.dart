import 'dart:convert';

import 'package:flutter/foundation.dart';

abstract class CacheSerializer<T, S> {
  Future<S> serialize(T data);

  Future<T> deserialize(S data);
}

class IdentitySerializer<T> implements CacheSerializer<T, T> {
  const IdentitySerializer();

  @override
  Future<T> serialize(T data) async => data;

  @override
  Future<T> deserialize(T data) async => data;
}

/// Serializer JSON avec hooks de post-traitement
class JsonSerializer<T> implements CacheSerializer<T, String> {
  JsonSerializer({
    required this.fromJson,
    required this.toJson,
    this.onDeserialize,
  });

  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Future<T> Function(T)? onDeserialize;

  @override
  Future<String> serialize(T data) async {
    return compute<T, String>((data) {
      final json = toJson(data);
      return jsonEncode(json);
    }, data);
  }

  @override
  Future<T> deserialize(String data) async {
    var result = await compute<String, T>((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    }, data);

    if (onDeserialize != null) {
      result = await onDeserialize!(result);
    }

    return result;
  }
}

/// Serializer String <-> Bytes
class StringBytesSerializer implements CacheSerializer<String, List<int>> {
  const StringBytesSerializer();

  @override
  Future<List<int>> serialize(String data) async => utf8.encode(data);

  @override
  Future<String> deserialize(List<int> data) async => utf8.decode(data);
}

/// Serializer Uint8List <-> List<int> (identité car compatibles)
class Uint8ListToListIntSerializer
    implements CacheSerializer<Uint8List, List<int>> {
  const Uint8ListToListIntSerializer();

  @override
  Future<List<int>> serialize(Uint8List data) async => data;

  @override
  Future<Uint8List> deserialize(List<int> data) async {
    return data is Uint8List ? data : Uint8List.fromList(data);
  }
}

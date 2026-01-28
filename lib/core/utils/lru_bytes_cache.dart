import 'dart:typed_data';

class LruBytesCache {
  LruBytesCache(this.maxEntries);

  final int maxEntries;
  final _map = <String, Uint8List>{};

  Uint8List? get(String key) {
    final v = _map.remove(key);
    if (v == null) return null;
    _map[key] = v; // refresh LRU
    return v;
  }

  Uint8List put(String key, Uint8List value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > maxEntries) {
      _map.remove(_map.keys.first);
    }
    return value;
  }
}

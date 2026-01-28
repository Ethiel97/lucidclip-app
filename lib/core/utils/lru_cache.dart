class LruCache<T> {
  LruCache(this.maxEntries);

  final int maxEntries;
  final _map = <String, T>{};

  T? get(String key) {
    final v = _map.remove(key);
    if (v == null) return null;
    _map[key] = v; // refresh LRU
    return v;
  }

  bool containsKey(String key) => _map.containsKey(key);

  T put(String key, T value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > maxEntries) {
      _map.remove(_map.keys.first);
    }
    return value;
  }
}

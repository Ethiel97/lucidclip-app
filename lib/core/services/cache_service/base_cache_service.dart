abstract class CacheService<T> {
  Future<T?> get(String key);

  Future<void> put({required String key, required T data, Duration? ttl});

  Future<void> remove(String key);

  Future<void> clear();

  Future<bool> contains(String key);
}

class CacheEntry<T> {
  CacheEntry({required this.data, this.expiresAt, this.canExpire});

  final T data;
  final DateTime? expiresAt;
  final bool Function()? canExpire;

  bool get isExpired =>
      canExpire != null &&
      canExpire!() &&
      expiresAt != null &&
      DateTime.now().toUtc().isAfter(expiresAt!);
}

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/storage/storage.dart';

@LazySingleton(as: SecureStorageService)
class PrefsSecureStorageService implements SecureStorageService {
  const PrefsSecureStorageService({required this.prefs});

  final EncryptedSharedPreferences prefs;

  static const _namespace = 'lucidclip.';

  String _k(String key) => '$_namespace$key';

  @override
  Future<void> initialize() async {}

  @override
  Future<void> write({required String key, required String value}) async {
    await prefs.setString(_k(key), value);
  }

  @override
  Future<String?> read({required String key}) async {
    return prefs.getString(_k(key));
  }

  @override
  Future<bool> containsKey(String key) async {
    return (await read(key: key)) != null;
  }

  @override
  Future<void> delete({required String key}) async {
    await prefs.remove(_k(key));
  }

  @override
  Future<void> deleteAll() async {
    final keys = prefs
        .getKeys()
        .where((k) => k.startsWith(_namespace))
        .toList();
    for (final k in keys) {
      await prefs.remove(k);
    }
  }

  @override
  Future<Set<String>> getAllKeys() async {
    return prefs
        .getKeys()
        .where((k) => k.startsWith(_namespace))
        .map((k) => k.substring(_namespace.length))
        .toSet();
  }

  @override
  Future<Map<String, String>> readAll() async {
    final out = <String, String>{};
    for (final k in prefs.getKeys().where((k) => k.startsWith(_namespace))) {
      final v = prefs.getString(k);
      if (v != null) out[k.substring(_namespace.length)] = v;
    }
    return out;
  }

  @override
  @disposeMethod
  Future<void> dispose() async {}
}

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EncryptedSupabaseStorage extends LocalStorage {
  EncryptedSupabaseStorage(this._prefs);

  final EncryptedSharedPreferences _prefs;

  // Supabase uses this key to persist session data
  static const String _sessionKey = 'supabase.auth.token';

  @override
  Future<void> initialize() async {
    // EncryptedSharedPreferences is already initialized in bootstrap
    // No additional initialization needed
  }

  @override
  Future<String?> accessToken() async {
    return _prefs.getString(_sessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _prefs.setString(_sessionKey, persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    await _prefs.remove(_sessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    final token = await accessToken();
    return token != null && token.isNotEmpty;
  }
}

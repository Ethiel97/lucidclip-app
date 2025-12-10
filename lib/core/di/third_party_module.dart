import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  ClipboardDatabase get clipboardDatabase => ClipboardDatabase();
}

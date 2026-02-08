import 'package:app_links/app_links.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';
import 'package:lucid_clip/features/settings/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;

  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @singleton
  AppLinks get appLinks => AppLinks();

  @singleton
  EntitlementDatabase get entitlementDatabase => EntitlementDatabase();

  @singleton
  ClipboardDatabase get clipboardDatabase => ClipboardDatabase();

  @singleton
  SettingsDatabase get settingsDatabase => SettingsDatabase();

  @lazySingleton
  WindowManager get windowManager => WindowManager.instance;

  @lazySingleton
  AutoUpdater get autoUpdater => AutoUpdater.instance;
}

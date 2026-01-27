import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/firebase_options.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await dotenv.load();

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  try {
    await Future.wait<void>([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      Supabase.initialize(
        url: AppConstants.supabaseProjectUrl,
        debug: true,
        anonKey: AppConstants.supabasePublishableKey,
      ),
    ]);
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      log('Firebase already initialized, skipping...');
    } else {
      rethrow;
    }
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  configureDependencies();

  await Future.wait<void>([
    getIt<WindowController>().initialize(),
    getIt<TrayManagerService>().initialize(),
    // Initialize hotkey manager
    getIt<HotkeyManagerService>().initialize(),
  ]);

  await Future.wait<void>([
    getIt<HotkeyManagerService>().registerDefaultHotkeys(),
    getIt<WindowController>().bootstrapWindow(),
  ]);

  // Only clear app data in development when explicitly needed
  // await clearAppData();

  runApp(await builder());
}

Future<void> resetClipboardDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final clipboardDbFile = File(p.join(dir.path, 'clipboard_db.sqlite'));
  if (clipboardDbFile.existsSync()) {
    await clipboardDbFile.delete();
  }
}

Future<void> resetSettingsDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final settingsDbFile = File(p.join(dir.path, 'settings_db.sqlite'));
  if (settingsDbFile.existsSync()) {
    await settingsDbFile.delete();
  }
}

Future<void> resetEntitlementsDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final entitlementsDbFile = File(p.join(dir.path, 'entitlement_db.sqlite'));
  if (entitlementsDbFile.existsSync()) {
    await entitlementsDbFile.delete();
  }
}

Future<void> clearAppData() async {
  await Future.wait<void>([
    HydratedBloc.storage.clear(),
    resetEntitlementsDatabase(),
    resetClipboardDatabase(),
    resetSettingsDatabase(),
  ]);
}

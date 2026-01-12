import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/firebase_options.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      log('Firebase already initialized, skipping...');
    } else {
      rethrow;
    }
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationSupportDirectory()).path,
    ),
  );

  //configure dependencies here
  // Must add this line.
  await windowManager.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseProjectUrl,
    debug: true,
    anonKey: AppConstants.supabasePublishableKey,
  );

  configureDependencies();

  const windowOptions = WindowOptions(
    minimumSize: Size(800, 500),
    size: Size(800, 500),
    center: true,
    title: 'LucidClip',
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    // maximumSize: Size(1200, 900),
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setPreventClose(true);
    await windowManager.show();
    await windowManager.focus();
  });

  await getIt<TrayManagerService>().initialize();

  // Only clear app data in development when explicitly needed
  // await clearAppData();

  runApp(await builder());
}

Future<void> resetClipboardDatabase() async {
  final dir = await getLibraryDirectory();
  final clipboardDbFile = File(p.join(dir.path, 'clipboard_db.sqlite'));
  if (clipboardDbFile.existsSync()) {
    await clipboardDbFile.delete();
  }
}

Future<void> resetSettingsDatabase() async {
  final dir = await getLibraryDirectory();
  final settingsDbFile = File(p.join(dir.path, 'settings_db.sqlite'));
  if (settingsDbFile.existsSync()) {
    await settingsDbFile.delete();
  }
}

Future<void> clearAppData() async {
  await HydratedBloc.storage.clear();
  await resetClipboardDatabase();
  await resetSettingsDatabase();
}

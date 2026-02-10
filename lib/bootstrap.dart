import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/firebase_options.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
    // Also capture in observability
    unawaited(
      Observability.captureException(
        error,
        stackTrace: stackTrace,
        hint: {'bloc': bloc.runtimeType.toString()},
      ),
    );
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Initialize Sentry as early as possible
  await _initializeSentry(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set up error handlers to capture in Sentry
    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
      // Capture in Sentry
      unawaited(
        Sentry.captureException(details.exception, stackTrace: details.stack),
      );
    };

    Bloc.observer = const AppBlocObserver();

    // Add cross-flavor configuration here
    try {
      await Future.wait<void>([
        EncryptedSharedPreferences.initialize(
          AppConstants.secureStorageEncryptionKey,
        ),
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        Supabase.initialize(
          anonKey: AppConstants.supabasePublishableKey,
          url: AppConstants.supabaseProjectUrl,
          debug: !AppConstants.isProd,
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

    await configureDependencies();

    // Initialize Observability facade
    Observability.initialize(getIt<ObservabilityService>());

    getIt<DeepLinkService>();
    unawaited(getIt<HotkeyManagerService>().registerDefaultHotkeys());
    await Future.wait<void>([getIt<WindowController>().bootstrapWindow()]);
    // Only clear app data in development when explicitly needed
    // await clearAppData();

    runApp(await builder());
  });
}

/// Initializes Sentry with privacy-first configuration.
Future<void> _initializeSentry(Future<void> Function() appRunner) async {
  // Skip Sentry in development/debug mode
  if (!AppConstants.isProd || AppConstants.sentryDsn.isEmpty) {
    log('Sentry disabled (non-production or no DSN)');
    await appRunner();
    return;
  }

  // Get package info for release tracking
  PackageInfo? packageInfo;
  try {
    packageInfo = await PackageInfo.fromPlatform();
  } catch (e) {
    log(
      'Failed to get package info for Sentry release tracking. '
      'Version info will not be included in Sentry events. Error: $e',
    );
  }

  await SentryFlutter.init((options) {
    options
      ..dsn = AppConstants.sentryDsn
      ..environment = _getEnvironmentName()
      ..release = packageInfo != null
          ? '${packageInfo.version}+${packageInfo.buildNumber}'
          : 'unknown' // Fallback to ensure version tracking always occurs
      // Privacy: beforeSend hook to scrub sensitive data
      ..beforeSend = SentryObservabilityService.beforeSend
      // Only capture errors, not performance traces by default
      ..tracesSampleRate = 0.0
      // Enable breadcrumbs for debugging context
      ..enableAutoSessionTracking = true
      ..attachScreenshot =
          false // Privacy: no screenshots
      ..attachViewHierarchy =
          false // Privacy: no view hierarchy
      // Diagnostic logging in debug
      ..debug = false
      // Desktop-specific options
      ..enableWindowMetricBreadcrumbs =
          false // Privacy
      ..sendDefaultPii =
          false // Privacy: never send PII
      ..maxBreadcrumbs = 50
      ..maxAttachmentSize = 1024 * 1024; // 1MB limit
  }, appRunner: appRunner);
}

/// Determines the environment name for Sentry.
String _getEnvironmentName() {
  if (AppConstants.isProd) return 'production';
  // You can add more logic here based on other environment variables
  // For now, we'll use a simple isProd check
  return 'development';
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

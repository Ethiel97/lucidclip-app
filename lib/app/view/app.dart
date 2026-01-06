import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/routes/routes.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/theme/app_theme.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

final appRouter = AppRouter();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener {
  final TrayManagerService _trayService = getIt<TrayManagerService>();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    // Start watching clipboard changes after app is initialized
    _trayService.startWatchingClipboard();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    // Hide window instead of closing when close button is clicked
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..loadSettings(null),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  final TrayManagerService _trayService = getIt<TrayManagerService>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update menu with localized strings
    _trayService.updateTrayMenu();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final settings = state.settings.value;
        final themeMode = _getThemeMode(settings?.theme ?? 'dark');
        return Portal(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: const AppTheme().light,
            darkTheme: const AppTheme().dark,
            themeMode: themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter.config(),
          ),
        );
      },
    );
  }

  ThemeMode _getThemeMode(String theme) => switch (theme.toLowerCase()) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.system,
    _ => ThemeMode.dark,
  };
}

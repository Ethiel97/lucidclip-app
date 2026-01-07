import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/routes/app_routes.gr.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

@lazySingleton
class TrayManagerService with TrayListener {
  TrayManagerService() {
    trayManager.addListener(this);
  }

  bool _isInitialized = false;
  StreamSubscription<ClipboardState>? _clipboardSubscription;
  StreamSubscription<SettingsState>? _settingsSubscription;

  /// Initialize the tray icon and menu
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set the tray icon based on platform
      final iconPath = _getTrayIconPath();
      await trayManager.setIcon(iconPath);

      // Build and set the initial menu
      await updateTrayMenu();

      _isInitialized = true;
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing tray manager',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
      rethrow;
    }
  }

  /// Start watching clipboard changes to update tray menu.
  /// This should be called after the app is fully initialized.
  void startWatchingClipboard() {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      _clipboardSubscription = clipboardCubit.stream.listen(
        (_) {
          // Update tray menu whenever clipboard state changes
          // Don't await to avoid blocking the stream
          unawaited(
            updateTrayMenu().catchError((Object error, StackTrace stackTrace) {
              developer.log(
                'Error updating tray menu from clipboard stream',
                error: error,
                stackTrace: stackTrace,
                name: 'TrayManagerService',
              );
            }),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          developer.log(
            'Error watching clipboard for tray updates',
            error: error,
            stackTrace: stackTrace,
            name: 'TrayManagerService',
          );
        },
      );

      // Also watch settings changes to update menu when incognito mode changes
      final settingsCubit = getIt<SettingsCubit>();
      _settingsSubscription = settingsCubit.stream.listen(
        (_) {
          // Update tray menu whenever settings change
          unawaited(
            updateTrayMenu().catchError((Object error, StackTrace stackTrace) {
              developer.log(
                'Error updating tray menu from settings stream',
                error: error,
                stackTrace: stackTrace,
                name: 'TrayManagerService',
              );
            }),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          developer.log(
            'Error watching settings for tray updates',
            error: error,
            stackTrace: stackTrace,
            name: 'TrayManagerService',
          );
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error setting up clipboard watcher',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Get the appropriate tray icon path for the current platform
  String _getTrayIconPath() {
    if (Platform.isMacOS) {
      return 'assets/icons/icon.png';
    } else if (Platform.isWindows) {
      return 'assets/icons/icon.ico';
    } else {
      // Fallback for Linux or other platforms
      return 'assets/icons/icon.png';
    }
  }

  /// Update the tray menu with current clipboard items
  Future<void> updateTrayMenu() async {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      final clipboardItems = clipboardCubit.state.clipboardItems.data;

      // Get settings to check incognito mode
      final settingsCubit = getIt<SettingsCubit>();
      final isIncognito =
          settingsCubit.state.settings.value?.incognitoMode ?? false;

      // Get localized strings if context is available
      final l10n = appRouter.navigatorKey.currentContext?.l10n;

      // Get last 5 items
      final recentItems = clipboardItems.take(8).toList();

      // Build submenu items for clipboard history
      final historyMenuItems = <MenuItem>[];

      if (recentItems.isEmpty) {
        historyMenuItems.add(
          MenuItem(
            key: 'empty_history',
            label: l10n?.noClipboardHistory ?? 'No clipboard history',
            disabled: true,
          ),
        );
      } else {
        for (var i = 0; i < recentItems.length; i++) {
          final item = recentItems[i];
          final preview = _getItemPreview(item);

          historyMenuItems.add(
            MenuItem(
              key: 'clipboard_item_$i',
              label: preview,
              disabled: true, // Preview only, clicking won't do anything
            ),
          );
        }
      }

      // Build the main menu
      final menu = Menu(
        items: [
          MenuItem(key: 'show_hide', label: 'Show/Hide Window'),
          MenuItem.separator(),
          MenuItem.submenu(
            key: 'private_session',
            label: isIncognito
                ? (l10n?.resumeTracking ?? 'Resume Tracking')
                : (l10n?.startPrivateSession ?? 'Start Private Session'),
            submenu: Menu(
              items: isIncognito
                  ? [
                      MenuItem(
                        key: 'stop_private_session',
                        label: l10n?.resumeTracking ?? 'Resume Tracking',
                      ),
                    ]
                  : [
                      MenuItem(
                        key: 'private_session_15min',
                        label: l10n?.fifteenMinutes ?? '15 Minutes',
                      ),
                      MenuItem(
                        key: 'private_session_1hour',
                        label: l10n?.oneHour ?? '1 Hour',
                      ),
                      MenuItem(
                        key: 'private_session_until_disabled',
                        label: l10n?.untilDisabled ?? 'Until Disabled',
                      ),
                    ],
            ),
          ),
          MenuItem.separator(),
          MenuItem.submenu(
            key: 'clipboard_history',
            label: l10n?.clipboardHistory ?? 'Clipboard History',
            submenu: Menu(items: historyMenuItems),
          ),
          MenuItem(
            key: 'clear_history',
            label: l10n?.clearClipboardHistory ?? 'Clear Clipboard History',
          ),
          MenuItem.separator(),
          MenuItem(key: 'settings', label: l10n?.settings ?? 'Settings'),
          MenuItem.separator(),
          MenuItem(key: 'about', label: l10n?.about ?? 'About'),
          MenuItem.separator(),
          MenuItem(key: 'quit', label: l10n?.quit ?? 'Quit'),
        ],
      );

      await trayManager.setContextMenu(menu);
    } catch (e, stackTrace) {
      developer.log(
        'Error updating tray menu',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Get a preview string for a clipboard item (max 50 chars)
  String _getItemPreview(ClipboardItem item) {
    var preview = '';

    preview = switch (item.type) {
      ClipboardItemType.text => item.content,
      ClipboardItemType.image => '📷 Image',
      ClipboardItemType.file => '📁 File: ${item.filePath ?? "Unknown"}',
      ClipboardItemType.url => '🔗 ${item.content}',
      ClipboardItemType.html => '📄 HTML Content',
      _ => 'Unknown type',
    };

    // Truncate to 50 characters
    if (preview.length > 50) {
      preview = '${preview.substring(0, 47)}...';
    }

    return preview;
  }

  @override
  void onTrayIconMouseDown() {
    // Optional: Handle tray icon mouse down
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    // Optional: Handle right click
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    _handleMenuItemClick(menuItem.key ?? '');
  }

  /// Handle menu item clicks
  Future<void> _handleMenuItemClick(String key) async {
    switch (key) {
      case 'show_hide':
        await _toggleWindowVisibility();
      case 'stop_private_session':
        await _stopPrivateSession();
      case 'private_session_15min':
        await _startPrivateSession(15);
      case 'private_session_1hour':
        await _startPrivateSession(60);
      case 'private_session_until_disabled':
        await _startPrivateSession(null);
      case 'clear_history':
        await _clearClipboardHistory();
      case 'settings':
        await _openSettings();
      case 'quit':
        await _quit();
      default:
    }
  }

  /// Toggle main window visibility
  Future<void> _toggleWindowVisibility() async {
    try {
      final isVisible = await windowManager.isVisible();

      if (isVisible) {
        await windowManager.hide();
      } else {
        await windowManager.show();
        await windowManager.focus();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error toggling window visibility',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Toggle clipboard tracking (incognito mode)
  Future<void> _toggleTracking() async {
    try {
      final settingsCubit = getIt<SettingsCubit>();
      final currentIncognito =
          settingsCubit.state.settings.value?.incognitoMode ?? false;

      // Toggle incognito mode
      await settingsCubit.updateIncognitoMode(incognitoMode: !currentIncognito);

      // Update the tray menu to reflect the change
      await updateTrayMenu();
    } catch (e, stackTrace) {
      developer.log(
        'Error toggling tracking',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Start a private session with the specified duration
  /// [durationMinutes] - Duration in minutes (null = until disabled)
  Future<void> _startPrivateSession(int? durationMinutes) async {
    try {
      final settingsCubit = getIt<SettingsCubit>();
      await settingsCubit.startPrivateSession(
        durationMinutes: durationMinutes,
      );

      // Update the tray menu to reflect the change
      await updateTrayMenu();
    } catch (e, stackTrace) {
      developer.log(
        'Error starting private session',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Stop the current private session
  Future<void> _stopPrivateSession() async {
    try {
      final settingsCubit = getIt<SettingsCubit>();
      await settingsCubit.updateIncognitoMode(incognitoMode: false);

      // Update the tray menu to reflect the change
      await updateTrayMenu();
    } catch (e, stackTrace) {
      developer.log(
        'Error stopping private session',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Clear clipboard history
  Future<void> _clearClipboardHistory() async {
    try {
      final localClipboardRepository = getIt<LocalClipboardRepository>();

      // Clear all items from the repository
      await localClipboardRepository.clear();

      // Update the tray menu after clearing
      await updateTrayMenu();
    } catch (e, stackTrace) {
      developer.log(
        'Error clearing clipboard history',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Open settings page
  Future<void> _openSettings() async {
    try {
      // First, show the window if it's hidden
      final isVisible = await windowManager.isVisible();
      if (!isVisible) {
        await windowManager.show();
        await windowManager.focus();
      }

      final context = appRouter.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        await appRouter.navigate(
          const LucidClipRoute(children: [SettingsRoute()]),
        );
      }

      developer.log('Opening settings...', name: 'TrayManagerService');
    } catch (e, stackTrace) {
      developer.log(
        'Error opening settings',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Quit the application
  Future<void> _quit() async {
    try {
      // Remove the prevent close flag
      await windowManager.setPreventClose(false);

      // Destroy the window
      await windowManager.destroy();
    } catch (e, stackTrace) {
      developer.log(
        'Error quitting application',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Dispose resources
  @disposeMethod
  void dispose() {
    _clipboardSubscription?.cancel();
    _settingsSubscription?.cancel();
    trayManager.removeListener(this);
  }
}

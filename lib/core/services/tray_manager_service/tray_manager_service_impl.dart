import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/feedback/feedback.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:tray_manager/tray_manager.dart';

@LazySingleton(as: TrayManagerService)
class TrayManagerServiceImpl with TrayListener implements TrayManagerService {
  TrayManagerServiceImpl() {
    trayManager.addListener(this);

    initialize();
  }

  bool _isInitialized = false;
  StreamSubscription<ClipboardState>? _clipboardSubscription;
  StreamSubscription<SettingsState>? _settingsSubscription;

  final windowController = getIt<WindowController>();

  /// Initialize the tray icon and menu
  ///
  @override
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
  @override
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
      return 'assets/icons/icon_white.png';
    } else if (Platform.isWindows) {
      return 'assets/icons/icon.ico';
    } else {
      // Fallback for Linux or other platforms
      return 'assets/icons/icon_white.png';
    }
  }

  /// Update the tray menu with current clipboard items
  @override
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
          final clipboardItem = recentItems[i];
          final preview = _getItemPreview(clipboardItem);

          // fresh instance of windowController to ensure
          // we have the latest previousFrontmostApp info
          final windowController = getIt<WindowController>();

          historyMenuItems.add(
            MenuItem(
              key: 'clipboard_item_$i',
              label: preview,
              toolTip: (windowController.previousFrontmostApp?.isValid ?? false)
                  ? (l10n?.pasteToApp(
                          windowController.previousFrontmostApp!.name,
                        ) ??
                        //ignore: lines_longer_than_80_chars
                        'Paste to ${windowController.previousFrontmostApp?.name}')
                  : null,
              onClick: (item) async {
                final previousApp = windowController.previousFrontmostApp;
                final isPreviousAppValid =
                    previousApp != null && previousApp.isValid;

                if (isPreviousAppValid) {
                  await getIt<ClipboardDetailCubit>().handlePasteToApp(
                    bundleId: previousApp.bundleId,
                    clipboardItem: clipboardItem,
                  );
                }
              },
            ),
          );
          if (i < recentItems.length - 1) {
            historyMenuItems.add(MenuItem.separator());
          }
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
          MenuItem(
            key: 'copy_last_item',
            label: l10n?.copyLastItem ?? 'Copy Last Item',
          ),
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
          MenuItem(
            key: 'send_feedback',
            label: l10n?.sendFeedback ?? 'Send Feedback',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'check_updates',
            label: l10n?.checkForUpdates ?? 'Check for Updates',
          ),
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
      case 'check_updates':
        await getIt<AppUpdateService>().checkFromMenu();
      case 'copy_last_item':
        await _copyLastItem();
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
      case 'send_feedback':
        await _sendFeedback();
      case 'quit':
        await _quit();
      default:
    }
  }

  /// Toggle main window visibility
  Future<void> _toggleWindowVisibility() async {
    try {
      await windowController.toggle();
    } catch (e, stackTrace) {
      developer.log(
        'Error toggling window visibility',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  Future<void> _copyLastItem() async {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      final clipboardDetailCubit = getIt<ClipboardDetailCubit>();
      final clipboardItems = clipboardCubit.state.clipboardItems.data;

      if (clipboardItems.isNotEmpty) {
        final lastItem = clipboardItems.first;
        await clipboardDetailCubit.copyToClipboard(lastItem);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error copying last clipboard item',
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
      await settingsCubit.startPrivateSession(durationMinutes: durationMinutes);

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
      await settingsCubit.updateIncognitoMode();

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
      await getIt<ClipboardCubit>().clearClipboard();
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
      await windowController.showAsOverlay();

      final context = appRouter.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        developer.log(
          'Navigating to settings page...',
          name: 'TrayManagerService',
        );
        await appRouter.navigate(
          LucidClipRoute(
            children: [
              SettingsRouterRoute(children: [SettingsRoute()]),
            ],
          ),
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error opening settings',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Request feedback UI to be shown
  Future<void> _sendFeedback() async {
    try {
      // First, show the window if it's hidden
      await windowController.showAsOverlay();

      // Request feedback via the FeedbackCubit
      // The listener in the app will handle showing the UI
      getIt<FeedbackCubit>().requestFeedback();

      developer.log(
        'Feedback requested from tray menu',
        name: 'TrayManagerService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error requesting feedback',
        error: e,
        stackTrace: stackTrace,
        name: 'TrayManagerService',
      );
    }
  }

  /// Quit the application
  Future<void> _quit() async {
    try {
      await windowController.quit();
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
  @override
  void dispose() {
    _clipboardSubscription?.cancel();
    _settingsSubscription?.cancel();
    trayManager.removeListener(this);
  }
}

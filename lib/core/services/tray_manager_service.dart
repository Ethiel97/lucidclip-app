import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/features/clipboard/presentation/cubit/cubit.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

@lazySingleton
class TrayManagerService with TrayListener {
  TrayManagerService() {
    trayManager.addListener(this);
  }

  bool _isInitialized = false;
  StreamSubscription<ClipboardItems>? _clipboardSubscription;

  /// Initialize the tray icon and menu
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set the tray icon based on platform
      final iconPath = _getTrayIconPath();
      await trayManager.setIcon(iconPath);

      // Build and set the initial menu
      await updateTrayMenu();

      // Listen to clipboard changes to update menu dynamically
      _startWatchingClipboard();

      _isInitialized = true;
    } catch (e) {
      print('Error initializing tray manager: $e');
      rethrow;
    }
  }

  /// Start watching clipboard changes to update tray menu
  void _startWatchingClipboard() {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      _clipboardSubscription = clipboardCubit.stream.listen((_) {
        // Update tray menu whenever clipboard state changes
        updateTrayMenu();
      });
    } catch (e) {
      print('Error setting up clipboard watcher: $e');
    }
  }

  /// Get the appropriate tray icon path for the current platform
  String _getTrayIconPath() {
    if (Platform.isMacOS) {
      return 'assets/icons/tray_icon.png';
    } else if (Platform.isWindows) {
      return 'assets/icons/tray_icon.ico';
    } else {
      // Fallback for Linux or other platforms
      return 'assets/icons/tray_icon.png';
    }
  }

  /// Update the tray menu with current clipboard items
  Future<void> updateTrayMenu() async {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      final clipboardItems = clipboardCubit.state.clipboardItems.data;

      // Get last 5 items
      final recentItems = clipboardItems.take(5).toList();

      // Build submenu items for clipboard history
      final historyMenuItems = <MenuItem>[];
      
      if (recentItems.isEmpty) {
        historyMenuItems.add(
          MenuItem(
            key: 'empty_history',
            label: 'No clipboard history',
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
          MenuItem(
            key: 'show_hide',
            label: 'Show/Hide Window',
          ),
          MenuItem.separator(),
          MenuItem.submenu(
            key: 'clipboard_history',
            label: 'Clipboard History',
            submenu: Menu(items: historyMenuItems),
          ),
          MenuItem(
            key: 'clear_history',
            label: 'Clear Clipboard History',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'settings',
            label: 'Settings',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'about',
            label: 'About',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'quit',
            label: 'Quit',
          ),
        ],
      );

      await trayManager.setContextMenu(menu);
    } catch (e) {
      print('Error updating tray menu: $e');
    }
  }

  /// Get a preview string for a clipboard item (max 50 chars)
  String _getItemPreview(ClipboardItem item) {
    String preview = '';
    
    switch (item.type) {
      case ClipboardItemType.text:
        preview = item.content;
        break;
      case ClipboardItemType.image:
        preview = '📷 Image';
        break;
      case ClipboardItemType.file:
        preview = '📁 File: ${item.filePath ?? "Unknown"}';
        break;
      case ClipboardItemType.url:
        preview = '🔗 ${item.content}';
        break;
      case ClipboardItemType.html:
        preview = '📄 HTML Content';
        break;
      default:
        preview = 'Unknown type';
    }

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
        break;
      case 'clear_history':
        await _clearClipboardHistory();
        break;
      case 'settings':
        await _openSettings();
        break;
      case 'about':
        await _showAbout();
        break;
      case 'quit':
        await _quit();
        break;
      default:
        // Ignore other menu items (like clipboard previews)
        break;
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
    } catch (e) {
      print('Error toggling window visibility: $e');
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
    } catch (e) {
      print('Error clearing clipboard history: $e');
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
      
      // TODO: Navigate to settings page using router
      // For now, just ensure window is visible
      print('Opening settings...');
    } catch (e) {
      print('Error opening settings: $e');
    }
  }

  /// Show about dialog
  Future<void> _showAbout() async {
    try {
      // First, show the window if it's hidden
      final isVisible = await windowManager.isVisible();
      if (!isVisible) {
        await windowManager.show();
        await windowManager.focus();
      }
      
      // TODO: Show about dialog
      print('Showing about dialog...');
    } catch (e) {
      print('Error showing about: $e');
    }
  }

  /// Quit the application
  Future<void> _quit() async {
    try {
      // Remove the prevent close flag
      await windowManager.setPreventClose(false);
      
      // Destroy the window and quit
      await windowManager.destroy();
      
      // Exit the application
      exit(0);
    } catch (e) {
      print('Error quitting application: $e');
      exit(1);
    }
  }

  /// Dispose resources
  @disposeMethod
  void dispose() {
    _clipboardSubscription?.cancel();
    trayManager.removeListener(this);
  }
}

import 'package:hotkey_manager/hotkey_manager.dart';

/// Enum for predefined shortcut actions
enum ShortcutAction {
  showWindow,
  toggleIncognito,
  clearClipboard,
  searchClipboard;

  String get key => switch (this) {
        ShortcutAction.showWindow => 'show_window',
        ShortcutAction.toggleIncognito => 'toggle_incognito',
        ShortcutAction.clearClipboard => 'clear_clipboard',
        ShortcutAction.searchClipboard => 'search_clipboard',
      };
}

/// Interface for managing application hotkeys
abstract class HotkeyManagerService {
  /// Initialize the hotkey manager
  Future<void> initialize();

  /// Register a hotkey for a specific action
  Future<void> registerHotkey(ShortcutAction action, HotKey hotKey);

  /// Unregister a hotkey for a specific action
  Future<void> unregisterHotkey(ShortcutAction action);

  /// Unregister all hotkeys
  Future<void> unregisterAll();

  /// Get the current hotkey for an action
  HotKey? getHotkey(ShortcutAction action);

  /// Get all registered hotkeys
  Map<ShortcutAction, HotKey> getAllHotkeys();

  /// Register default hotkeys
  Future<void> registerDefaultHotkeys();

  /// Load shortcuts from a map (e.g., from user settings)
  Future<void> loadShortcutsFromMap(Map<String, String> shortcuts);

  /// Dispose resources
  Future<void> dispose();
}

import 'package:hotkey_manager/hotkey_manager.dart';

/// Enum for predefined shortcut actions
enum ShortcutAction {
  toggleWindow,
  toggleIncognito,
  clearClipboard,
  searchClipboard;

  String get key => switch (this) {
    ShortcutAction.toggleWindow => 'toggle_window',
    ShortcutAction.toggleIncognito => 'toggle_incognito',
    ShortcutAction.clearClipboard => 'clear_clipboard',
    ShortcutAction.searchClipboard => 'search_clipboard',
  };

  bool get isToggleWindow => this == ShortcutAction.toggleWindow;

  bool get isToggleIncognito => this == ShortcutAction.toggleIncognito;

  bool get isClearClipboard => this == ShortcutAction.clearClipboard;

  bool get isSearchClipboard => this == ShortcutAction.searchClipboard;

  static ShortcutAction? fromKey(String key) {
    for (final action in ShortcutAction.values) {
      if (action.key == key) {
        return action;
      }
    }
    return null;
  }
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

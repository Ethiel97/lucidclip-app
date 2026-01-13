import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/hotkey_manager_service/hotkey_manager_service_interface.dart';
import 'package:lucid_clip/core/utils/hotkey_utils.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

/// Implementation of HotkeyManagerService using hotkey_manager package
@LazySingleton(as: HotkeyManagerService)
class HotkeyManagerServiceImpl implements HotkeyManagerService {
  HotkeyManagerServiceImpl();

  final Map<ShortcutAction, HotKey> _registeredHotkeys = {};
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize hotkey manager (required on some platforms)
      await hotKeyManager.unregisterAll();
      _isInitialized = true;

      developer.log('Hotkey manager initialized', name: 'HotkeyManagerService');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing hotkey manager',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
      rethrow;
    }
  }

  @override
  Future<void> registerHotkey(ShortcutAction action, HotKey hotKey) async {
    try {
      // Unregister existing hotkey for this action if any
      await unregisterHotkey(action);

      // Register the new hotkey with appropriate handler
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (_) => _handleHotkeyPress(action),
      );

      _registeredHotkeys[action] = hotKey;

      developer.log(
        'Registered hotkey for ${action.key}: ${hotKey.toJson()}',
        name: 'HotkeyManagerService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error registering hotkey for ${action.key}',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
      rethrow;
    }
  }

  @override
  Future<void> unregisterHotkey(ShortcutAction action) async {
    final hotKey = _registeredHotkeys[action];
    if (hotKey != null) {
      try {
        await hotKeyManager.unregister(hotKey);
        _registeredHotkeys.remove(action);

        developer.log(
          'Unregistered hotkey for ${action.key}',
          name: 'HotkeyManagerService',
        );
      } catch (e, stackTrace) {
        developer.log(
          'Error unregistering hotkey for ${action.key}',
          error: e,
          stackTrace: stackTrace,
          name: 'HotkeyManagerService',
        );
        rethrow;
      }
    }
  }

  @override
  Future<void> unregisterAll() async {
    try {
      await hotKeyManager.unregisterAll();
      _registeredHotkeys.clear();

      developer.log('Unregistered all hotkeys', name: 'HotkeyManagerService');
    } catch (e, stackTrace) {
      developer.log(
        'Error unregistering all hotkeys',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
      rethrow;
    }
  }

  @override
  HotKey? getHotkey(ShortcutAction action) {
    return _registeredHotkeys[action];
  }

  @override
  Map<ShortcutAction, HotKey> getAllHotkeys() {
    return Map.unmodifiable(_registeredHotkeys);
  }

  @override
  Future<void> registerDefaultHotkeys() async {
    try {
      // Show Window: Cmd/Ctrl + Shift + V
      final showWindowHotkey = HotKey(
        key: PhysicalKeyboardKey.keyV,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
      );
      await registerHotkey(ShortcutAction.toggleWindow, showWindowHotkey);

      // Toggle Incognito: Cmd/Ctrl + Shift + I
      final toggleIncognitoHotkey = HotKey(
        key: PhysicalKeyboardKey.keyI,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
      );
      await registerHotkey(
        ShortcutAction.toggleIncognito,
        toggleIncognitoHotkey,
      );

      developer.log('Registered default hotkeys', name: 'HotkeyManagerService');
    } catch (e, stackTrace) {
      developer.log(
        'Error registering default hotkeys',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
      // Don't rethrow - default hotkeys are optional
    }
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await unregisterAll();
    _isInitialized = false;
  }

  @override
  Future<void> loadShortcutsFromMap(Map<String, String> shortcuts) async {
    try {
      for (final entry in shortcuts.entries) {
        // Find the action that matches this key, skip unknown actions
        ShortcutAction? action;
        for (final shortcutAction in ShortcutAction.values) {
          if (shortcutAction.key == entry.key) {
            action = shortcutAction;
            break;
          }
        }

        if (action == null) {
          developer.log(
            'Skipping unknown shortcut action: ${entry.key}. '
            'Available actions:'
            ' ${ShortcutAction.values.map((a) => a.key).join(", ")}',
            name: 'HotkeyManagerService',
          );
          continue;
        }

        // Parse the hotkey string using shared utility
        final hotkey = HotkeyUtils.parseHotkeyString(entry.value);
        if (hotkey != null) {
          await registerHotkey(action, hotkey);
        }
      }

      developer.log(
        'Loaded ${shortcuts.length} shortcuts from settings',
        name: 'HotkeyManagerService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error loading shortcuts from map',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
      // Don't rethrow - loading shortcuts is optional
    }
  }

  /// Handle hotkey press for different actions
  Future<void> _handleHotkeyPress(ShortcutAction action) async {
    try {
      developer.log(
        'Hotkey pressed: ${action.key}',
        name: 'HotkeyManagerService',
      );

      switch (action) {
        case ShortcutAction.toggleWindow:
          await _handleToggleWindow();
        case ShortcutAction.toggleIncognito:
          await _handleToggleIncognito();
        case ShortcutAction.clearClipboard:
          await _handleClearClipboard();
        case ShortcutAction.searchClipboard:
          await _handleSearchClipboard();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error handling hotkey press for ${action.key}',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
    }
  }

  /// Show or focus the application window
  Future<void> _handleToggleWindow() async {
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
        'Error toggling window',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
    }
  }

  /// Toggle incognito mode
  Future<void> _handleToggleIncognito() async {
    try {
      final settingsCubit = getIt<SettingsCubit>();
      final currentSettings = settingsCubit.state.settings.value;
      if (currentSettings != null) {
        await settingsCubit.updateIncognitoMode(
          incognitoMode: !currentSettings.incognitoMode,
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error toggling incognito mode',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
    }
  }

  /// Clear clipboard history
  Future<void> _handleClearClipboard() async {
    try {
      final clipboardCubit = getIt<ClipboardCubit>();
      await clipboardCubit.clear();
    } catch (e, stackTrace) {
      developer.log(
        'Error clearing clipboard',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
    }
  }

  /// Focus on search (show window and focus search)
  Future<void> _handleSearchClipboard() async {
    try {
      await _handleToggleWindow();
      // TODO(Ethiel): Focus search input when this feature is added
    } catch (e, stackTrace) {
      developer.log(
        'Error handling search clipboard',
        error: e,
        stackTrace: stackTrace,
        name: 'HotkeyManagerService',
      );
    }
  }
}

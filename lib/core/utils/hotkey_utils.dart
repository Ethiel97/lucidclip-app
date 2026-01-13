import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

/// Utility class for keyboard shortcut helpers
class HotkeyUtils {
  HotkeyUtils._();

  /// Map of key characters to PhysicalKeyboardKey
  static final Map<String, PhysicalKeyboardKey> keyMap = {
    'a': PhysicalKeyboardKey.keyA,
    'b': PhysicalKeyboardKey.keyB,
    'c': PhysicalKeyboardKey.keyC,
    'd': PhysicalKeyboardKey.keyD,
    'e': PhysicalKeyboardKey.keyE,
    'f': PhysicalKeyboardKey.keyF,
    'g': PhysicalKeyboardKey.keyG,
    'h': PhysicalKeyboardKey.keyH,
    'i': PhysicalKeyboardKey.keyI,
    'j': PhysicalKeyboardKey.keyJ,
    'k': PhysicalKeyboardKey.keyK,
    'l': PhysicalKeyboardKey.keyL,
    'm': PhysicalKeyboardKey.keyM,
    'n': PhysicalKeyboardKey.keyN,
    'o': PhysicalKeyboardKey.keyO,
    'p': PhysicalKeyboardKey.keyP,
    'q': PhysicalKeyboardKey.keyQ,
    'r': PhysicalKeyboardKey.keyR,
    's': PhysicalKeyboardKey.keyS,
    't': PhysicalKeyboardKey.keyT,
    'u': PhysicalKeyboardKey.keyU,
    'v': PhysicalKeyboardKey.keyV,
    'w': PhysicalKeyboardKey.keyW,
    'x': PhysicalKeyboardKey.keyX,
    'y': PhysicalKeyboardKey.keyY,
    'z': PhysicalKeyboardKey.keyZ,
    '0': PhysicalKeyboardKey.digit0,
    '1': PhysicalKeyboardKey.digit1,
    '2': PhysicalKeyboardKey.digit2,
    '3': PhysicalKeyboardKey.digit3,
    '4': PhysicalKeyboardKey.digit4,
    '5': PhysicalKeyboardKey.digit5,
    '6': PhysicalKeyboardKey.digit6,
    '7': PhysicalKeyboardKey.digit7,
    '8': PhysicalKeyboardKey.digit8,
    '9': PhysicalKeyboardKey.digit9,
    'space': PhysicalKeyboardKey.space,
    'enter': PhysicalKeyboardKey.enter,
    'escape': PhysicalKeyboardKey.escape,
    'esc': PhysicalKeyboardKey.escape,
  };

  /// Convert a key string to PhysicalKeyboardKey
  static PhysicalKeyboardKey? parsePhysicalKey(String keyString) {
    return keyMap[keyString.toLowerCase()];
  }

  /// Get human-readable label for a key
  static String getKeyLabel(PhysicalKeyboardKey? key) {
    if (key == null) return '';

    // Reverse lookup in keyMap
    for (final entry in keyMap.entries) {
      if (entry.value == key) {
        return entry.key.toUpperCase();
      }
    }

    // Fallback to debug name
    return key.debugName?.replaceFirst('Key', '').toUpperCase() ?? '';
  }

  /// Convert a HotKey to a human-readable string
  static String hotkeyToString(HotKey? hotkey) {
    if (hotkey == null) return '';

    final modifiers = <String>[];
    if (hotkey.modifiers?.contains(HotKeyModifier.control) ?? false) {
      modifiers.add('Ctrl');
    }
    if (hotkey.modifiers?.contains(HotKeyModifier.shift) ?? false) {
      modifiers.add('Shift');
    }
    if (hotkey.modifiers?.contains(HotKeyModifier.alt) ?? false) {
      modifiers.add('Alt');
    }
    if (hotkey.modifiers?.contains(HotKeyModifier.meta) ?? false) {
      modifiers.add('Cmd');
    }

    final keyLabel = getKeyLabel(hotkey.key);
    return [...modifiers, keyLabel].join(' + ');
  }

  /// Parse a hotkey string like "Ctrl+Shift+V" into a HotKey object
  static HotKey? parseHotkeyString(String? hotkeyString) {
    if (hotkeyString == null || hotkeyString.isEmpty) return null;

    try {
      final parts = hotkeyString.split('+').map((e) => e.trim()).toList();
      if (parts.isEmpty) return null;

      final modifiers = <HotKeyModifier>[];
      PhysicalKeyboardKey? key;

      for (final part in parts) {
        switch (part.toLowerCase()) {
          case 'ctrl':
          case 'control':
            modifiers.add(HotKeyModifier.control);
          case 'shift':
            modifiers.add(HotKeyModifier.shift);
          case 'alt':
            modifiers.add(HotKeyModifier.alt);
          case 'cmd':
          case 'meta':
            modifiers.add(HotKeyModifier.meta);
          default:
            // Try to parse the key
            key = parsePhysicalKey(part);
        }
      }

      if (key == null) return null;

      return HotKey(
        key: key,
        modifiers: modifiers,
        scope: HotKeyScope.system,
      );
    } catch (e) {
      return null;
    }
  }
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:lucid_clip/core/services/hotkey_manager_service/hotkey_manager_service_interface.dart';

void main() {
  group('ShortcutAction', () {
    test('should have unique keys for all actions', () {
      final keys = ShortcutAction.values.map((e) => e.key).toSet();
      expect(keys.length, ShortcutAction.values.length);
    });

    test('should provide correct key for showWindow', () {
      expect(ShortcutAction.toggleWindow.key, 'show_window');
    });

    test('should provide correct key for toggleIncognito', () {
      expect(ShortcutAction.toggleIncognito.key, 'toggle_incognito');
    });

    test('should provide correct key for clearClipboard', () {
      expect(ShortcutAction.clearClipboard.key, 'clear_clipboard');
    });

    test('should provide correct key for searchClipboard', () {
      expect(ShortcutAction.searchClipboard.key, 'search_clipboard');
    });
  });

  group('HotKey serialization', () {
    test('should create hotkey with modifiers and key', () {
      final hotkey = HotKey(
        key: PhysicalKeyboardKey.keyV,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );

      expect(hotkey.key, PhysicalKeyboardKey.keyV);
      expect(
        hotkey.modifiers,
        containsAll([HotKeyModifier.control, HotKeyModifier.shift]),
      );
      expect(hotkey.scope, HotKeyScope.system);
    });

    test('should convert hotkey to json and back', () {
      final hotkey = HotKey(
        key: PhysicalKeyboardKey.keyI,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );

      final json = hotkey.toJson();
      expect(json, isNotNull);
      expect(json, isA<Map<String, dynamic>>());
    });
  });
}

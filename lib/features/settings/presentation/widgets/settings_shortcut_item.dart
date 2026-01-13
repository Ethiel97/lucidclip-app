import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:tinycolor2/tinycolor2.dart';

/// Widget for displaying and editing a keyboard shortcut
class SettingsShortcutItem extends StatefulWidget {
  const SettingsShortcutItem({
    required this.title,
    required this.description,
    required this.hotkey,
    required this.onChanged,
    this.onReset,
    super.key,
  });

  final String title;
  final String description;
  final HotKey? hotkey;
  final ValueChanged<HotKey?> onChanged;
  final VoidCallback? onReset;

  @override
  State<SettingsShortcutItem> createState() => _SettingsShortcutItemState();
}

class _SettingsShortcutItemState extends State<SettingsShortcutItem> {
  bool _isRecording = false;
  final FocusNode _focusNode = FocusNode();
  HotKey? _recordedHotkey;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordedHotkey = null;
    });
    _focusNode.requestFocus();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _focusNode.unfocus();
    if (_recordedHotkey != null) {
      widget.onChanged(_recordedHotkey);
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isRecording) return;
    if (event is! KeyDownEvent) return;

    final modifiers = <HotKeyModifier>[];
    
    // Detect modifiers
    if (HardwareKeyboard.instance.isControlPressed) {
      modifiers.add(HotKeyModifier.control);
    }
    if (HardwareKeyboard.instance.isShiftPressed) {
      modifiers.add(HotKeyModifier.shift);
    }
    if (HardwareKeyboard.instance.isAltPressed) {
      modifiers.add(HotKeyModifier.alt);
    }
    if (HardwareKeyboard.instance.isMetaPressed) {
      modifiers.add(HotKeyModifier.meta);
    }

    // Only record if we have at least one modifier and a non-modifier key
    if (modifiers.isNotEmpty && 
        event.physicalKey != PhysicalKeyboardKey.controlLeft &&
        event.physicalKey != PhysicalKeyboardKey.controlRight &&
        event.physicalKey != PhysicalKeyboardKey.shiftLeft &&
        event.physicalKey != PhysicalKeyboardKey.shiftRight &&
        event.physicalKey != PhysicalKeyboardKey.altLeft &&
        event.physicalKey != PhysicalKeyboardKey.altRight &&
        event.physicalKey != PhysicalKeyboardKey.metaLeft &&
        event.physicalKey != PhysicalKeyboardKey.metaRight) {
      
      setState(() {
        _recordedHotkey = HotKey(
          key: event.physicalKey,
          modifiers: modifiers,
          scope: HotKeyScope.system,
        );
      });
      
      // Stop recording after a short delay to show the key combination
      Future.delayed(const Duration(milliseconds: 300), _stopRecording);
    }
  }

  String _hotkeyToString(HotKey? hotkey) {
    if (hotkey == null) return 'Not set';
    
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
    
    final keyLabel = _getKeyLabel(hotkey.key);
    return [...modifiers, keyLabel].join(' + ');
  }

  String _getKeyLabel(PhysicalKeyboardKey? key) {
    if (key == null) return '';
    
    // Common keys mapping
    final keyMap = {
      PhysicalKeyboardKey.keyA: 'A',
      PhysicalKeyboardKey.keyB: 'B',
      PhysicalKeyboardKey.keyC: 'C',
      PhysicalKeyboardKey.keyD: 'D',
      PhysicalKeyboardKey.keyE: 'E',
      PhysicalKeyboardKey.keyF: 'F',
      PhysicalKeyboardKey.keyG: 'G',
      PhysicalKeyboardKey.keyH: 'H',
      PhysicalKeyboardKey.keyI: 'I',
      PhysicalKeyboardKey.keyJ: 'J',
      PhysicalKeyboardKey.keyK: 'K',
      PhysicalKeyboardKey.keyL: 'L',
      PhysicalKeyboardKey.keyM: 'M',
      PhysicalKeyboardKey.keyN: 'N',
      PhysicalKeyboardKey.keyO: 'O',
      PhysicalKeyboardKey.keyP: 'P',
      PhysicalKeyboardKey.keyQ: 'Q',
      PhysicalKeyboardKey.keyR: 'R',
      PhysicalKeyboardKey.keyS: 'S',
      PhysicalKeyboardKey.keyT: 'T',
      PhysicalKeyboardKey.keyU: 'U',
      PhysicalKeyboardKey.keyV: 'V',
      PhysicalKeyboardKey.keyW: 'W',
      PhysicalKeyboardKey.keyX: 'X',
      PhysicalKeyboardKey.keyY: 'Y',
      PhysicalKeyboardKey.keyZ: 'Z',
      PhysicalKeyboardKey.digit0: '0',
      PhysicalKeyboardKey.digit1: '1',
      PhysicalKeyboardKey.digit2: '2',
      PhysicalKeyboardKey.digit3: '3',
      PhysicalKeyboardKey.digit4: '4',
      PhysicalKeyboardKey.digit5: '5',
      PhysicalKeyboardKey.digit6: '6',
      PhysicalKeyboardKey.digit7: '7',
      PhysicalKeyboardKey.digit8: '8',
      PhysicalKeyboardKey.digit9: '9',
      PhysicalKeyboardKey.space: 'Space',
      PhysicalKeyboardKey.enter: 'Enter',
      PhysicalKeyboardKey.escape: 'Esc',
    };
    
    return keyMap[key] ?? key.debugName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isRecording
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxs),
                      Text(
                        widget.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onTertiary
                              .toTinyColor()
                              .darken()
                              .color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isRecording
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _isRecording
                          ? (_recordedHotkey != null
                              ? _hotkeyToString(_recordedHotkey)
                              : l10n.pressKeyCombination)
                          : _hotkeyToString(widget.hotkey),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _isRecording
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (!_isRecording) ...[
                  IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedEdit02,
                      color: colorScheme.primary,
                    ),
                    tooltip: l10n.editShortcut,
                    onPressed: _startRecording,
                  ),
                  if (widget.onReset != null)
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedRefresh,
                        color: colorScheme.secondary,
                      ),
                      tooltip: l10n.resetToDefault,
                      onPressed: widget.onReset,
                    ),
                ] else
                  TextButton(
                    onPressed: _stopRecording,
                    child: Text(l10n.cancel),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

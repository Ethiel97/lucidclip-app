import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/hotkey_utils.dart';
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
    if (modifiers.isNotEmpty && !_isModifierKey(event.physicalKey)) {
      setState(() {
        _recordedHotkey = HotKey(key: event.physicalKey, modifiers: modifiers);
      });

      // Stop recording after a short delay to show the key combination
      Future.delayed(const Duration(milliseconds: 300), _stopRecording);
    }
  }

  /// Check if a physical key is a modifier key
  static bool _isModifierKey(PhysicalKeyboardKey key) {
    final modifierKeys = {
      PhysicalKeyboardKey.controlLeft,
      PhysicalKeyboardKey.controlRight,
      PhysicalKeyboardKey.shiftLeft,
      PhysicalKeyboardKey.shiftRight,
      PhysicalKeyboardKey.altLeft,
      PhysicalKeyboardKey.altRight,
      PhysicalKeyboardKey.metaLeft,
      PhysicalKeyboardKey.metaRight,
    };
    return modifierKeys.contains(key);
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
                                ? HotkeyUtils.hotkeyToString(_recordedHotkey)
                                : l10n.pressKeyCombination)
                          : (widget.hotkey != null
                                ? HotkeyUtils.hotkeyToString(widget.hotkey)
                                : l10n.notSet),
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

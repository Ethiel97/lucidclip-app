# Keyboard Shortcuts Feature

This document describes the keyboard shortcuts feature implementation for LucidClip.

## Overview

The keyboard shortcuts feature allows users to configure global hotkeys to quickly interact with the application without needing to open the window first.

## Architecture

### Components

1. **HotkeyManagerService** (`lib/core/services/hotkey_manager_service/`)
   - Interface-based service following the app's pattern
   - Manages registration, unregistration, and handling of keyboard shortcuts
   - Uses the `hotkey_manager` package for cross-platform support

2. **Settings Integration**
   - Keyboard shortcuts are stored in the `UserSettings` entity
   - Persisted both locally and remotely (if authenticated)
   - Managed through the `SettingsCubit`

3. **UI Components**
   - `SettingsShortcutItem`: Widget for displaying and editing individual shortcuts
   - Keyboard shortcuts section in the Settings view
   - Interactive key recording functionality

## Default Shortcuts

| Action | Default Shortcut | Description |
|--------|-----------------|-------------|
| Show Window | Ctrl+Shift+V | Brings the application window to focus |
| Toggle Incognito | Ctrl+Shift+I | Enables/disables incognito mode |

## Available Actions

The following actions are defined in `ShortcutAction` enum:

- `showWindow`: Show and focus the application window
- `toggleIncognito`: Toggle incognito mode on/off
- `clearClipboard`: Clear all clipboard history (can be configured by user)
- `searchClipboard`: Open window and focus search (can be configured by user)

## How to Use

### For Users

1. Navigate to Settings > Keyboard Shortcuts
2. Click the "Edit" button next to a shortcut
3. Press the desired key combination (must include at least one modifier key)
4. The shortcut is automatically saved and registered
5. Use the "Reset to Default" button to restore default shortcuts

### For Developers

#### Adding a New Shortcut Action

1. Add the action to the `ShortcutAction` enum in `hotkey_manager_service_interface.dart`
2. Add the handler in `HotkeyManagerServiceImpl._handleHotkeyPress()`
3. Add localization strings in `lib/l10n/arb/app_en.arb`
4. Add UI element in `_KeyboardShortcutsSection` widget
5. (Optional) Add default shortcut in `registerDefaultHotkeys()` and `_resetToDefault()`

#### Example: Adding a "Copy Last Item" Shortcut

```dart
// 1. Add to enum
enum ShortcutAction {
  // ... existing actions
  copyLastItem;
  
  String get key => switch (this) {
    // ... existing cases
    ShortcutAction.copyLastItem => 'copy_last_item',
  };
}

// 2. Add handler
Future<void> _handleHotkeyPress(ShortcutAction action) async {
  // ... existing code
  switch (action) {
    // ... existing cases
    case ShortcutAction.copyLastItem:
      await _handleCopyLastItem();
  }
}

Future<void> _handleCopyLastItem() async {
  final clipboardCubit = getIt<ClipboardCubit>();
  final lastItem = clipboardCubit.state.items.firstOrNull;
  if (lastItem != null) {
    await clipboardCubit.copyToClipboard(lastItem);
  }
}

// 3. Add localizations (in app_en.arb)
"copyLastItemShortcut": "Copy Last Item",
"copyLastItemShortcutDescription": "Copy the most recent clipboard item"

// 4. Add UI in _KeyboardShortcutsSection
SettingsShortcutItem(
  title: l10n.copyLastItemShortcut,
  description: l10n.copyLastItemShortcutDescription,
  hotkey: _parseHotkey(
    widget.settings.shortcuts[ShortcutAction.copyLastItem.key],
  ),
  onChanged: (hotkey) =>
      _updateHotkey(ShortcutAction.copyLastItem, hotkey),
  onReset: () => _resetToDefault(ShortcutAction.copyLastItem),
)
```

## Technical Details

### Hotkey Storage Format

Shortcuts are stored as strings in the format: `"Modifier1+Modifier2+Key"`

Example: `"Ctrl+Shift+V"`

### Platform Support

The `hotkey_manager` package supports:
- ✅ Windows
- ✅ macOS
- ✅ Linux

### Modifiers

Supported modifier keys:
- `Ctrl` (Control)
- `Shift`
- `Alt`
- `Cmd` (Meta/Command on macOS)

### Scope

All shortcuts are registered with `HotKeyScope.system` for global accessibility.

## Initialization

The hotkey service is initialized in `bootstrap.dart` after dependency injection:

```dart
await getIt<HotkeyManagerService>().initialize();
await getIt<HotkeyManagerService>().registerDefaultHotkeys();
```

## Error Handling

- Shortcut conflicts are handled by the `hotkey_manager` package
- Failed registrations are logged but don't crash the app
- Users can always reset to defaults if a shortcut stops working

## Future Enhancements

Potential improvements:

1. Conflict detection and user warnings
2. Import/export shortcut configurations
3. Multiple shortcut profiles
4. Shortcut suggestions based on common workflows
5. Visual indicator when a shortcut is triggered
6. Platform-specific default shortcuts (e.g., Cmd instead of Ctrl on macOS)

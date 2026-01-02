# Settings Feature - Complete Guide

## Overview

This guide provides comprehensive information about the settings feature implementation for LucidClip, a modern clipboard manager built with Flutter/Dart.

---

## Table of Contents

1. [Architecture Decision](#architecture-decision)
2. [Quick Start](#quick-start)
3. [Feature Capabilities](#feature-capabilities)
4. [Technical Implementation](#technical-implementation)
5. [Usage Examples](#usage-examples)
6. [Build & Deploy](#build--deploy)
7. [Testing](#testing)
8. [Troubleshooting](#troubleshooting)

---

## Architecture Decision

### Question: Should settings be local-first like the clipboard?

**✅ YES - Settings are local-first**

### Why Local-First?

| Reason | Benefit |
|--------|---------|
| **Immediate Availability** | Settings (especially theme) available instantly on app startup |
| **Instant Feedback** | UI responds immediately to user changes without network delays |
| **Architectural Consistency** | Matches existing local-first pattern for clipboard data |
| **Offline Support** | Full functionality without internet connection |
| **Background Sync** | Supabase sync happens in background without blocking UI |
| **Multi-Device** | Settings automatically sync across devices when online |

### Data Flow

```
┌─────────────┐
│ User Action │
└──────┬──────┘
       │
       ▼
┌──────────────┐
│SettingsCubit │
└──────┬───────┘
       │
       ├──────────────────────────┐
       │                          │
       ▼                          ▼
┌──────────────┐          ┌──────────────┐
│  Local DB    │          │   UI Update  │
│  (Drift)     │          │  (Immediate) │
└──────┬───────┘          └──────────────┘
       │
       ▼
┌──────────────┐
│  Remote Sync │
│  (Supabase)  │
│  (Background)│
└──────────────┘
```

---

## Quick Start

### Prerequisites

- Flutter SDK >=3.8.0
- Dart SDK
- Supabase project configured
- LucidClip base app setup

### Installation

1. **Pull the feature branch**:
   ```bash
   git checkout copilot/create-settings-feature
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

### First-Time Setup

The settings feature will automatically:
1. Create local Drift database on first run
2. Initialize default settings if none exist
3. Sync to Supabase when user is authenticated

---

## Feature Capabilities

### 1. Theme Management

**Available Themes:**
- 🌞 Light Mode
- 🌙 Dark Mode
- 🔄 System (follows OS preference)

**Implementation:**
- Theme changes apply immediately
- Persisted locally and synced to cloud
- Supports both Material light and dark themes

### 2. Sync Configuration

**Auto Sync Settings:**
- Enable/disable automatic cloud sync
- Configurable sync interval: 1-60 minutes
- Background sync doesn't block UI

### 3. Clipboard Management

**Max History Items:**
- Range: 100 - 10,000 items
- Controls local database size
- Automatic cleanup of old items

**Retention Period:**
- Range: 1 - 365 days
- Automatically deletes old clipboard items
- Configurable per user preference

### 4. Display Preferences

**Pin on Top:**
- Keep pinned clipboard items at the top of the list

**Show Source App:**
- Display which application the clipboard item came from

**Preview Images:**
- Show image thumbnails in clipboard list

### 5. Keyboard Shortcuts (Planned)

- Stored as JSON in database
- UI for editing shortcuts coming in future update

---

## Technical Implementation

### Database Schema

**Local (Drift SQLite):**
```dart
class UserSettingsEntries extends Table {
  TextColumn get userId => text().named('user_id')();
  TextColumn get theme => text().withDefault(const Constant('dark'))();
  TextColumn get shortcutsJson => text().named('shortcuts_json').withDefault(const Constant('{}'))();
  BoolColumn get autoSync => boolean().named('auto_sync').withDefault(const Constant(false))();
  IntColumn get syncIntervalMinutes => integer().named('sync_interval_minutes').withDefault(const Constant(5))();
  IntColumn get maxHistoryItems => integer().named('max_history_items').withDefault(const Constant(1000))();
  IntColumn get retentionDays => integer().named('retention_days').withDefault(const Constant(30))();
  BoolColumn get pinOnTop => boolean().named('pin_on_top').withDefault(const Constant(true))();
  BoolColumn get showSourceApp => boolean().named('show_source_app').withDefault(const Constant(true))();
  BoolColumn get previewImages => boolean().named('preview_images').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
}
```

**Remote (Supabase PostgreSQL):**
- Matches local schema exactly
- Foreign key to `auth.users`
- Cascade delete on user deletion
- Constraint checks on theme values

### State Management

**SettingsCubit:**
```dart
class SettingsCubit extends HydratedCubit<SettingsState> {
  // Loads settings from local DB first, then syncs with remote
  Future<void> loadSettings(String userId);
  
  // Updates settings locally first, then syncs to remote
  Future<void> updateSettings(UserSettings settings);
  
  // Individual update methods for each setting
  Future<void> updateTheme(String theme);
  Future<void> updateAutoSync(bool autoSync);
  // ... more update methods
}
```

**State Persistence:**
- Uses `HydratedBloc` for automatic state persistence
- Survives app restarts
- Restores last known state immediately

### Dependency Injection

**Registration:**
```dart
@module
abstract class ThirdPartyModule {
  @singleton
  SettingsDatabase get settingsDatabase => SettingsDatabase();
}
```

**Usage:**
```dart
// In any widget
final cubit = getIt<SettingsCubit>();
```

---

## Usage Examples

### Accessing Settings in Code

```dart
// Get the current settings
BlocBuilder<SettingsCubit, SettingsState>(
  builder: (context, state) {
    final settings = state.settings;
    final currentTheme = settings?.theme ?? 'dark';
    return Text('Current theme: $currentTheme');
  },
);
```

### Updating Settings

```dart
// Update theme
context.read<SettingsCubit>().updateTheme('light');

// Update auto sync
context.read<SettingsCubit>().updateAutoSync(true);

// Update multiple settings at once
final newSettings = currentSettings.copyWith(
  theme: 'dark',
  autoSync: true,
  syncIntervalMinutes: 15,
);
context.read<SettingsCubit>().updateSettings(newSettings);
```

### Navigating to Settings

```dart
// From any screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const SettingsPage(),
  ),
);
```

---

## Build & Deploy

### Development Build

```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Run in development
flutter run
```

### Production Build

```bash
# Build for production
flutter build macos --release  # or windows, linux
```

### Continuous Code Generation

```bash
# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Database Migration

**Initial Setup:**
- Local database created automatically on first run
- Path: `{app_documents_directory}/settings_db.sqlite`

**Schema Changes:**
- Update `schemaVersion` in `SettingsDatabase`
- Add migration logic in `MigrationStrategy`
- Test with existing data

---

## Testing

### Unit Tests (Example)

```dart
void main() {
  group('SettingsCubit', () {
    late SettingsCubit cubit;
    
    setUp(() {
      cubit = SettingsCubit(
        localSettingsRepository: MockLocalSettingsRepository(),
        settingsRepository: MockSettingsRepository(),
      );
    });
    
    test('initial state is loading', () {
      expect(cubit.state.isLoading, true);
    });
    
    test('updateTheme updates settings', () async {
      await cubit.updateTheme('light');
      expect(cubit.state.settings?.theme, 'light');
    });
  });
}
```

### Widget Tests (Example)

```dart
testWidgets('SettingsView displays theme selector', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => mockSettingsCubit,
        child: const SettingsView(),
      ),
    ),
  );
  
  expect(find.text('Theme'), findsOneWidget);
  expect(find.text('Light'), findsOneWidget);
  expect(find.text('Dark'), findsOneWidget);
  expect(find.text('System'), findsOneWidget);
});
```

### Integration Tests

```dart
void main() {
  testWidgets('Settings sync to remote', (tester) async {
    // Test that local changes sync to Supabase
  });
  
  testWidgets('Settings persist across app restarts', (tester) async {
    // Test HydratedBloc persistence
  });
}
```

---

## Troubleshooting

### Common Issues

#### 1. Build Runner Fails

**Problem:** Code generation fails with errors

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. Settings Not Persisting

**Problem:** Settings reset after app restart

**Solution:**
- Check HydratedBloc is properly initialized in `bootstrap.dart`
- Verify storage directory permissions
- Check for errors in `SettingsState.toJson()` and `fromJson()`

#### 3. Theme Not Changing

**Problem:** Theme selection doesn't change app appearance

**Solution:**
- Verify `App` widget is using `BlocProvider` for `SettingsCubit`
- Check `MaterialApp.themeMode` is set from settings state
- Ensure both `theme` and `darkTheme` are defined

#### 4. Sync Not Working

**Problem:** Settings don't sync to Supabase

**Solution:**
- Verify Supabase project URL and API key in `.env`
- Check network connectivity
- Verify `user_settings` table exists in Supabase
- Check user is authenticated

#### 5. Database Error

**Problem:** "Table doesn't exist" error

**Solution:**
```dart
// In SettingsDatabase, increment schema version and add migration
@override
int get schemaVersion => 2; // Increment this

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1 && to == 2) {
      // Add migration logic
    }
  },
);
```

---

## File Structure

```
lib/features/settings/
├── data/
│   ├── data_sources/
│   │   ├── drift_settings_local_data_source.dart
│   │   ├── settings_local_data_source.dart
│   │   ├── settings_remote_data_source.dart
│   │   └── supabase_settings_remote_data_source.dart
│   ├── db/
│   │   ├── settings_database.dart
│   │   ├── settings_database.g.dart
│   │   └── settings_tables.dart
│   ├── models/
│   │   ├── user_settings_model.dart
│   │   └── user_settings_model.g.dart
│   └── repositories/
│       ├── local_settings_repository_impl.dart
│       └── settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user_settings.dart
│   └── repositories/
│       ├── local_settings_repository.dart
│       └── settings_repository.dart
└── presentation/
    ├── cubit/
    │   ├── settings_cubit.dart
    │   └── settings_state.dart
    └── view/
        ├── settings_page.dart
        └── settings_view.dart
```

---

## Performance Considerations

1. **Local-First**: Settings load from local DB (<10ms) before remote sync
2. **Background Sync**: Remote updates don't block UI
3. **HydratedBloc**: State persistence happens asynchronously
4. **Debouncing**: Multiple rapid changes batched into single sync

---

## Security

### Data Protection

- ✅ User-scoped settings (user_id required)
- ✅ Foreign key constraints
- ✅ Cascade delete on user removal
- ✅ Theme value validation
- ✅ Secure local storage
- ✅ No sensitive data in logs

### Best Practices

- Always validate user authentication before settings operations
- Use prepared statements (Drift handles this)
- Sanitize user input (constraints in database)
- Log errors without exposing sensitive data

---

## Future Enhancements

- [ ] Keyboard shortcuts editor UI
- [ ] Settings import/export
- [ ] Reset to defaults button
- [ ] Settings search functionality
- [ ] Time-based theme switching
- [ ] Settings sync status indicator
- [ ] Settings backup to file
- [ ] Settings profiles (work/personal)

---

## Support

For issues, questions, or contributions:
1. Check existing issues in the repository
2. Review this documentation
3. Create a new issue with:
   - Clear description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

---

## License

Part of LucidClip project - refer to main LICENSE file.

---

**Last Updated:** 2026-01-02  
**Version:** 1.0.0  
**Branch:** `copilot/create-settings-feature`

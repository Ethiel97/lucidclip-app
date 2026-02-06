# Settings Feature Refactoring Summary

## Overview

Refactored the settings feature to follow the **entitlement pattern**, unifying local and remote data fetching into a
single repository layer and simplifying the cubit logic.

## Changes Made

### 1. **Unified Settings Repository** (`SettingsRepository`)

Previously, we had two separate repositories:

- `SettingsRepository` - handled remote data only
- `LocalSettingsRepository` - handled local data only

**Now**: Single `SettingsRepository` that handles both local and remote, following the entitlement pattern:

#### New Interface Methods:

```dart
abstract class SettingsRepository {
  /// Returns local value if present, then attempts remote refresh.
  Future<UserSettings?> load(String userId);

  /// Force a remote refresh (and persist locally).
  Future<UserSettings?> refresh(String userId);

  /// Update settings (persists locally and syncs to remote).
  Future<void> update(UserSettings settings);

  /// Local stream (what UI should primarily listen to).
  Stream<UserSettings?> watchLocal(String userId);

  /// Subscribe remote realtime (websocket/channel).
  Future<void> startRealtime(String userId);

  Future<void> stopRealtime();

  Future<void> clearLocal(String userId);
}
```

#### Implementation Highlights:

#### Implementation Highlights:

- **`load()`**: Returns local data immediately, creates defaults if none exist, then triggers background refresh
- **`refresh()`**: Forces remote fetch and updates local cache
- **`watchLocal()`**: Single source of truth - UI listens to local DB stream
- **`startRealtime()`**: Subscribes to remote updates (Supabase realtime)
- **Icon enrichment**: Automatically enriches excluded apps with icons via `SourceAppIconService`
- **Default settings**: Automatically creates default settings if none exist locally

### 2. **Remote Data Source Refactoring**

Updated `SupabaseSettingsRemoteDataSource` to use subscription pattern:

**Before**:

```dart
Stream<UserSettingsModel?> watchSettings(String userId);
```

**After**:

```dart
Future<SettingsRemoteSubscription> subscribeSettings(String userId);
```

This matches the entitlement pattern where subscriptions are managed by the repository.

### 3. **LocalSettingsRepository as Adapter**

Kept `LocalSettingsRepository` for backward compatibility with existing code (RetentionCleanupService, SearchCubit,
ClipboardCubit).

**Now it's a lightweight facade that delegates to SettingsRepository:**

```dart
@LazySingleton(as: LocalSettingsRepository)
class LocalSettingsRepositoryImpl implements LocalSettingsRepository {
  final SettingsRepository settingsRepository;

  @override
  Future<UserSettings?> getSettings(String userId) async {
    return settingsRepository.load(userId);
  }

  @override
  Future<void> upsertSettings(UserSettings settings) async {
    await settingsRepository.update(settings);
  }
// ... delegates all methods
}
```

### 4. **Simplified SettingsCubit**

Removed all data fetching complexity from the cubit.

**Before**:

- Cubit managed both local and remote repositories
- Complex logic to sync local → remote
- Manual auth state handling
- Guest user fallback logic
- Default settings creation logic in cubit

**After**:

- Single `SettingsRepository` dependency
- Follows entitlement pattern with `boot()` method
- Auto-subscribes to auth state changes
- Repository handles all sync logic
- Repository handles default settings creation (cubit is cleaner)

#### Key Methods:

```dart
// Auto-called when user logs in
Future<void> boot(String userId) async {
  // 1. Start local stream (instant UI updates)
  _localSubscription = settingsRepository.watchLocal(userId).listen(...);

  // 2. Load local + trigger background refresh
  var local = await settingsRepository.load(userId);

  // 3. Create defaults if none exist
  if (local == null) {
    await settingsRepository.update(_createDefaultSettings());
  }

  // 4. Start realtime sync
  await settingsRepository.startRealtime(userId);
}

// Simplified update
Future<void> updateSettings(UserSettings settings) async {
  await settingsRepository.update(settings);
  // No need to emit - watchLocal stream handles it
}
```

### 5. **Data Flow**

#### On User Login:

1. AuthRepository emits user
2. SettingsCubit receives auth change → calls `boot(userId)`
3. `boot()` sets up local stream subscription
4. `boot()` calls `load()` → returns local immediately, triggers refresh
5. `boot()` calls `startRealtime()` → subscribes to Supabase realtime

#### On Settings Update:

1. UI calls `settingsCubit.updateSettings()`
2. Repository updates local DB (immediate)
3. Repository syncs to remote (best effort)
4. Local stream emits new value
5. Cubit receives update via stream → emits new state
6. UI updates

#### On Remote Update (from another device):

1. Supabase realtime sends update
2. Repository receives via subscription
3. Repository updates local DB
4. Local stream emits new value
5. Cubit receives update → emits new state
6. UI updates

### 6. **Benefits**

✅ **Single Source of Truth**: UI always listens to local DB stream
✅ **Offline-First**: Local data returned immediately, remote syncs in background
✅ **Realtime Sync**: Instant updates from other devices via Supabase realtime
✅ **Clean Separation**: Repository handles all data logic, Cubit handles UI state
✅ **Consistent Pattern**: Matches EntitlementCubit architecture
✅ **Easier Testing**: Repository layer is isolated and testable
✅ **Backward Compatible**: LocalSettingsRepository still works for existing code

### 7. **Files Modified**

#### Domain Layer:

- `lib/features/settings/domain/repositories/settings_repository.dart` - New interface

#### Data Layer:

- `lib/features/settings/data/repositories/settings_repository_impl.dart` - Unified implementation
- `lib/features/settings/data/repositories/local_settings_repository_impl.dart` - Now a facade
- `lib/features/settings/data/data_sources/settings_remote_data_source.dart` - Added subscription pattern
- `lib/features/settings/data/data_sources/supabase_settings_remote_data_source.dart` - Subscription implementation

#### Presentation Layer:

- `lib/features/settings/presentation/cubit/settings_cubit.dart` - Simplified, removed dual repository logic
- `lib/features/settings/presentation/view/settings_view.dart` - Updated to use `refreshSettings()`

#### App Layer:

- `lib/app/view/app.dart` - Removed manual `loadSettings()` call (now auto-boots)

#### Generated:

- `lib/core/di/injection.config.dart` - Updated dependency injection

## Migration Notes

### For Future Features

When creating new features that need similar patterns:

1. Create unified repository with `load()`, `refresh()`, `watchLocal()`, `startRealtime()`, `stopRealtime()`
2. Cubit listens to auth state changes
3. Cubit calls `boot(userId)` on login
4. Cubit subscribes to `watchLocal()` stream
5. Repository manages local ↔ remote sync transparently

### Breaking Changes

None - backward compatible via `LocalSettingsRepository` facade.

## Testing

- ✅ Static analysis passes (`flutter analyze`)
- ✅ Dependency injection regenerated successfully
- ✅ No compilation errors

## Date

February 5, 2026

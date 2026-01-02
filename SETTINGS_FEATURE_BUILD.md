# Settings Feature Build Instructions

This document outlines the build steps needed to complete the settings feature implementation.

## Code Generation

The settings feature requires code generation for:
1. Drift database (settings_database.g.dart) - COMPLETED MANUALLY
2. JSON serialization (user_settings_model.g.dart) - COMPLETED MANUALLY
3. Injectable dependency injection (injection.config.dart)

## Build Commands

To regenerate the code with the proper Flutter/Dart tools, run:

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Or for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

## What was implemented

### Local-First Architecture Decision

**Settings are local-first** for these reasons:
- Immediate availability on app startup (theme, UI preferences)
- Instant response to user changes without network delays
- Matches the existing local-first pattern used for clipboard data
- Background sync to Supabase for multi-device support
- Better offline experience

### Components Created

1. **Domain Layer** (`lib/features/settings/domain/`)
   - `entities/user_settings.dart` - Core settings entity
   - `repositories/settings_repository.dart` - Remote repository interface
   - `repositories/local_settings_repository.dart` - Local repository interface

2. **Data Layer** (`lib/features/settings/data/`)
   - `models/user_settings_model.dart` - JSON-serializable model
   - `db/settings_tables.dart` - Drift table definition
   - `db/settings_database.dart` - Drift database class
   - `data_sources/drift_settings_local_data_source.dart` - Local storage implementation
   - `data_sources/supabase_settings_remote_data_source.dart` - Remote sync implementation
   - `repositories/local_settings_repository_impl.dart` - Local repository
   - `repositories/settings_repository_impl.dart` - Remote repository

3. **Presentation Layer** (`lib/features/settings/presentation/`)
   - `cubit/settings_cubit.dart` - BLoC state management with HydratedCubit
   - `cubit/settings_state.dart` - Settings state class

4. **Dependency Injection**
   - Updated `lib/core/di/third_party_module.dart` to register SettingsDatabase

### Database Schema

The Drift local table matches the Supabase schema:
- user_id (PK)
- theme (default: 'dark')
- shortcuts (JSON)
- auto_sync (default: false)
- sync_interval_minutes (default: 5)
- max_history_items (default: 1000)
- retention_days (default: 30)
- pin_on_top (default: true)
- show_source_app (default: true)
- preview_images (default: true)
- created_at
- updated_at

### Next Steps

1. Run the build_runner command to regenerate DI config
2. Update app.dart to integrate SettingsCubit and use theme from settings
3. Create settings UI page
4. Test the implementation
5. Run linting and tests

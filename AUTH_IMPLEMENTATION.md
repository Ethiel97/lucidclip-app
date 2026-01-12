# GitHub OAuth Authentication Implementation

This document describes the GitHub OAuth authentication implementation for LucidClip.

## Overview

The authentication feature allows users to sign in with their GitHub account via Supabase Auth. Once authenticated, their clipboard data and settings can be synchronized across devices.

## Architecture

The implementation follows the clean architecture pattern with three main layers:

### Domain Layer (`lib/features/auth/domain/`)

#### Entities
- **User** (`entities/user.dart`): Core user entity with properties:
  - `id`: Unique user identifier from Supabase
  - `email`: User's email address
  - `userMetadata`: Additional metadata from OAuth provider
  - `createdAt`: Account creation timestamp

#### Repository Interface
- **AuthRepository** (`repositories/auth_repository.dart`): Defines authentication operations:
  - `signInWithGitHub()`: Initiates GitHub OAuth flow
  - `signOut()`: Signs out the current user
  - `getCurrentUser()`: Retrieves the currently authenticated user
  - `authStateChanges`: Stream of authentication state changes

### Data Layer (`lib/features/auth/data/`)

#### Models
- **UserModel** (`models/user_model.dart`): Extends User entity with JSON serialization
  - Converts from Supabase Auth user objects
  - Provides `toJson()` and `fromJson()` for persistence

#### Data Sources
- **SupabaseAuthDataSource** (`data_sources/supabase_auth_data_source.dart`):
  - Handles direct interaction with Supabase Auth
  - Manages OAuth flow with deep link redirect
  - Stores user data in secure storage
  - Listens to auth state changes

#### Repository Implementation
- **AuthRepositoryImpl** (`repositories/auth_repository_impl.dart`):
  - Implements AuthRepository interface
  - Delegates to SupabaseAuthDataSource
  - Converts between models and entities

### Presentation Layer (`lib/features/auth/presentation/`)

#### State Management
- **AuthCubit** (`cubit/auth_cubit.dart`): Manages authentication state
  - Initializes auth state on app start
  - Listens to auth state stream
  - Provides methods for sign in and sign out
  - Emits appropriate states (loading, authenticated, error, etc.)

- **AuthState** (`cubit/auth_state.dart`): Represents authentication state
  - `user`: Current user or null
  - `status`: AuthStatus enum (unauthenticated, loading, authenticated, error)
  - `errorMessage`: Optional error message

#### UI Components
- **LoginPage** (`view/login_page.dart`): Route wrapper with BLoC provider
- **LoginView** (`view/login_view.dart`): Login screen UI
  - Modern, minimal design with app branding
  - "Sign in with GitHub" button
  - Loading states and error handling
  - Responsive layout

## OAuth Flow

1. User clicks "Sign in with GitHub" on the login screen
2. `AuthCubit.signInWithGitHub()` is called
3. `SupabaseAuthDataSource.signInWithGitHub()` initiates OAuth:
   - Calls `supabase.auth.signInWithOAuth(OAuthProvider.github)`
   - Redirects to: `lucidclip://auth-callback`
4. User authenticates with GitHub in their browser
5. GitHub redirects back to the app via deep link
6. Supabase handles the callback and creates a session
7. Auth state stream emits the new user
8. `AuthCubit` updates state to authenticated
9. App navigates to main screen

## Deep Link Configuration

### macOS (`macos/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.lucidclip.auth</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>lucidclip</string>
    </array>
  </dict>
</array>
```

### Windows
Deep link handling on Windows is managed by the `url_launcher` package and system registry (configured during app installation).

## Secure Storage Integration

User authentication data is stored securely using `FlutterSecureStorage`:

- **User ID**: `SecureStorageConstants.userId`
- **User Email**: `SecureStorageConstants.userEmail`
- Session tokens are managed automatically by Supabase

## Integration with Existing Features

### Settings Sync
When a user is authenticated:
- `SettingsCubit.loadSettings(userId)` is called with the user's ID
- Settings are synchronized with Supabase
- Local and remote settings are merged

When a user is not authenticated:
- Settings are stored locally only
- A guest user ID is used

### Clipboard Sync
Authentication enables:
- Remote clipboard synchronization
- Association of clipboard items with user ID
- Cross-device clipboard access

## Routing

The app routing has been updated in `lib/core/routes/app_routes.dart`:

```dart
@override
List<AutoRoute> get routes => [
  AutoRoute(path: '/login', page: LoginRoute.page),
  AutoRoute(
    path: '/',
    page: LucidClipRoute.page,
    children: [
      // ... other routes
    ],
  ),
];
```

## App Initialization

In `lib/app/view/app.dart`:
- `AuthCubit` is provided at the root level
- Auth state changes trigger settings reload
- Initial auth check loads appropriate settings

## Error Handling

Custom exception added to `lib/core/errors/exceptions.dart`:
- **AuthenticationException**: Thrown for auth-related errors
  - OAuth failures
  - Network issues
  - Cancelled authentication
  - Invalid sessions

## Dependency Injection

All authentication components are registered with `injectable`:
- `@lazySingleton` for `SupabaseAuthDataSource`
- `@LazySingleton` for `AuthRepositoryImpl` (as `AuthRepository`)
- `@lazySingleton` for `AuthCubit`

Dependencies are auto-registered via code generation.

## Usage

### Sign In
```dart
context.read<AuthCubit>().signInWithGitHub();
```

### Sign Out
```dart
context.read<AuthCubit>().signOut();
```

### Check Auth State
```dart
final authState = context.watch<AuthCubit>().state;
if (authState.isAuthenticated) {
  final user = authState.user;
  // User is authenticated
}
```

### Listen to Auth State Changes
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state.isAuthenticated) {
      // Navigate to main screen
    } else if (state.hasError) {
      // Show error message
    }
  },
  child: // ...
)
```

## Code Generation

To generate required code files, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or using melos:

```bash
melos run generate-files
```

This generates:
- `user_model.g.dart`: JSON serialization for UserModel
- `app_routes.gr.dart`: Auto-generated routes
- `injection.config.dart`: Dependency injection configuration

## Environment Variables

The following environment variables should be configured in `.env`:

- `SUPABASE_PROJECT_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key
- `GITHUB_CLIENT_ID`: GitHub OAuth app client ID (configured in Supabase)
- `GITHUB_CLIENT_SECRET`: GitHub OAuth app secret (configured in Supabase)

## Supabase Setup

1. Create a project in Supabase
2. Navigate to Authentication → Providers
3. Enable GitHub provider
4. Configure GitHub OAuth app:
   - Authorization callback URL: `https://[YOUR-PROJECT-ID].supabase.co/auth/v1/callback`
5. Add the callback URL to allowed redirect URLs in Supabase Auth settings

## Testing

Key test scenarios:
- ✅ User can sign in with GitHub
- ✅ Session persists across app restarts
- ✅ User can sign out
- ✅ Auth state changes update settings
- ✅ Error handling for failed OAuth
- ✅ Error handling for cancelled OAuth
- ✅ Deep link callback handling

## Future Enhancements

Potential improvements:
- [ ] Support for additional OAuth providers (Google, Apple)
- [ ] Biometric authentication for quick access
- [ ] Multi-device session management
- [ ] Account linking (link multiple OAuth providers)
- [ ] Email/password authentication option
- [ ] Two-factor authentication support

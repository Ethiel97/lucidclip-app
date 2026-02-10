# Sentry Observability Integration

This document describes the Sentry observability integration for LucidClip, providing unified error tracking, breadcrumbs, and logging with privacy-first constraints.

## Architecture

The observability system follows the same hybrid pattern as Analytics:
1. **Interface**: `ObservabilityService` - Domain service contract
2. **Implementation**: `SentryObservabilityService` - Sentry-based implementation with privacy controls
3. **Injectable Registration**: `@LazySingleton(as: ObservabilityService)` annotation
4. **Static Facade**: `Observability` - Convenient static API for app-wide usage

## Setup

### 1. Dependencies

The following dependency has been added to `pubspec.yaml`:

```yaml
dependencies:
  sentry_flutter: ^8.12.0
```

Run `flutter pub get` to install.

### 2. Environment Configuration

Add the Sentry DSN to your environment configuration:

**For dart-define approach:**
```bash
--dart-define=SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id
```

**For environment files (if using):**
```json
{
  "SENTRY_DSN": "https://your-sentry-dsn@sentry.io/project-id"
}
```

The DSN is configured in `lib/core/constants/app_constants.dart`:
```dart
static const sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');
```

### 3. Initialization

Sentry is automatically initialized in `lib/bootstrap.dart` when the app starts:

- **Production only**: Sentry is disabled in development/debug mode (`!AppConstants.isProd`)
- **Error handlers**: Automatically captures Flutter errors, platform errors, and zone errors
- **Privacy**: `beforeSend` hook scrubs sensitive data before transmission
- **Release tracking**: Automatically sets release version from package info

The `Observability` facade is initialized in `bootstrap.dart` after dependency injection:

```dart
Observability.initialize(getIt<ObservabilityService>());
```

## Usage

### Basic Exception Capture

```dart
import 'package:lucid_clip/core/observability/observability_module.dart';

try {
  await riskyOperation();
} catch (e, st) {
  await Observability.captureException(
    e,
    stackTrace: st,
    hint: {'operation': 'riskyOperation'},
  );
  // Handle error gracefully
}
```

### Adding Breadcrumbs

Breadcrumbs create a trail of events leading up to errors:

```dart
// User action breadcrumb
await Observability.breadcrumb(
  'User clicked search button',
  category: 'user_action',
  level: 'info',
);

// Clipboard capture breadcrumb (privacy-safe metadata only)
await Observability.breadcrumb(
  'Clipboard item captured',
  category: 'clipboard',
  data: {
    'content_type': 'text',
    'content_length': 150,
    'source': 'keyboard_shortcut',
  },
  level: 'info',
);

// Navigation breadcrumb
await Observability.breadcrumb(
  'Navigated to settings',
  category: 'navigation',
  data: {'route': '/settings'},
  level: 'info',
);
```

### Capturing Messages

Send standalone log messages as events:

```dart
await Observability.message(
  'Failed to sync clipboard history',
  level: 'warning',
  extras: {
    'item_count': 42,
    'duration_ms': 1500,
  },
);
```

### User Context

Set user context (userId only by default for privacy):

```dart
// On login
await Observability.setUser(user.id);

// With optional email (use cautiously)
await Observability.setUser(
  user.id,
  email: user.email, // Only if user consented
);

// On logout
await Observability.clearUser();
```

### Tags and Context

Add custom tags for filtering:

```dart
// Set subscription tier
await Observability.setTag('subscription_tier', 'pro');

// Set custom context
await Observability.setContext('app_state', {
  'screen': 'clipboard_history',
  'item_count': items.length,
});
```

## Privacy & Security

### Automatic Data Scrubbing

The integration includes strong privacy controls:

1. **allowlist-based filtering**: Only approved context keys are sent
2. **beforeSend hook**: Scrubs sensitive data before transmission
3. **No clipboard contents**: Never sends actual clipboard data
4. **No PII by default**: Personal information is excluded
5. **Header filtering**: Only safe HTTP headers are included

### Allowed Context Keys

The following metadata keys are safe and allowed:

**Content metadata** (NOT the content itself):
- `content_length`, `content_type`, `mime_type`
- `file_extension`, `source`, `category`, `flags`
- `item_count`, `duration_ms`

**UI/Navigation context**:
- `screen`, `route`, `action`, `feature`

**System context**:
- `platform`, `os_version`, `app_version`, `locale`

Any other keys will be filtered out automatically.

### Adding New Allowed Keys

To add a new safe context key, update `_allowedContextKeys` in `sentry_observability_service.dart`:

```dart
static const _allowedContextKeys = {
  // ... existing keys ...
  'your_new_safe_key',
};
```

## Usage in Cubits/Blocs

### Example: Error Handling in ClipboardCubit

```dart
import 'package:lucid_clip/core/observability/observability_module.dart';

class ClipboardCubit extends Cubit<ClipboardState> {
  ClipboardCubit(this._repository) : super(const ClipboardState.initial());

  final ClipboardRepository _repository;

  Future<void> captureClipboardItem() async {
    emit(state.copyWith(status: ClipboardStatus.loading));

    // Add breadcrumb for context
    await Observability.breadcrumb(
      'Starting clipboard capture',
      category: 'clipboard',
      level: 'info',
    );

    try {
      final item = await _repository.captureCurrentClipboard();
      
      // Success breadcrumb with safe metadata
      await Observability.breadcrumb(
        'Clipboard item captured successfully',
        category: 'clipboard',
        data: {
          'content_type': item.type.name,
          'content_length': item.content.length,
        },
        level: 'info',
      );

      emit(state.copyWith(
        status: ClipboardStatus.success,
        item: item,
      ));
    } catch (e, st) {
      // Capture exception with context
      await Observability.captureException(
        e,
        stackTrace: st,
        hint: {
          'action': 'clipboard_capture',
          'item_count': state.items.length,
        },
      );

      // Error breadcrumb
      await Observability.breadcrumb(
        'Clipboard capture failed',
        category: 'clipboard',
        level: 'error',
      );

      emit(state.copyWith(
        status: ClipboardStatus.error,
        errorMessage: 'Failed to capture clipboard',
      ));
    }
  }
}
```

### Example: Network Request Logging

```dart
Future<User> fetchUser(String userId) async {
  await Observability.breadcrumb(
    'Fetching user data',
    category: 'http',
    data: {'action': 'fetch_user'},
    level: 'info',
  );

  try {
    final response = await _dio.get('/users/$userId');
    return User.fromJson(response.data);
  } catch (e, st) {
    await Observability.captureException(
      e,
      stackTrace: st,
      hint: {'action': 'fetch_user'},
    );
    rethrow;
  }
}
```

## Migration from print/log statements

Replace debug logging with breadcrumbs or messages:

### Before:
```dart
print('User navigated to settings');
log('Clipboard item captured: ${item.content}'); // ❌ Logs sensitive data
```

### After:
```dart
await Observability.breadcrumb(
  'User navigated to settings',
  category: 'navigation',
  level: 'debug',
);

await Observability.breadcrumb(
  'Clipboard item captured',
  category: 'clipboard',
  data: {
    'content_type': item.type.name,
    'content_length': item.content.length, // ✅ Metadata only
  },
  level: 'info',
);
```

### Migration Guidelines

1. **Replace `print()` statements**: Use `Observability.breadcrumb()` for tracking user actions
2. **Replace `log()` for errors**: Use `Observability.captureException()` in catch blocks
3. **Replace `log()` for important events**: Use `Observability.message()` for significant events
4. **Never log sensitive data**: Always use metadata (length, type, source) instead of actual content

## Performance Monitoring (Future)

Performance tracing is currently disabled (`tracesSampleRate: 0.0`) to focus on errors and breadcrumbs only.

To enable performance monitoring in the future:

1. Update `bootstrap.dart` to set `tracesSampleRate`:
   ```dart
   options.tracesSampleRate = AppConstants.isProd ? 0.1 : 0.0;
   ```

2. Add performance tracking in critical operations:
   ```dart
   final transaction = Sentry.startTransaction('clipboard.capture', 'task');
   try {
     // Operation
     transaction.status = SpanStatus.ok();
   } catch (e) {
     transaction.status = SpanStatus.internalError();
   } finally {
     await transaction.finish();
   }
   ```

## Testing

### Unit Testing

Mock the `ObservabilityService` in tests:

```dart
class MockObservabilityService extends Mock implements ObservabilityService {}

void main() {
  late MockObservabilityService mockObservability;
  late MyCubit cubit;

  setUp(() {
    mockObservability = MockObservabilityService();
    cubit = MyCubit(mockObservability);
  });

  test('captures exception on error', () async {
    // Arrange
    when(() => mockObservability.captureException(any(), stackTrace: any()))
        .thenAnswer((_) async {});

    // Act
    await cubit.riskyOperation();

    // Assert
    verify(() => mockObservability.captureException(any(), stackTrace: any()))
        .called(1);
  });
}
```

## Troubleshooting

### Sentry not capturing events

1. **Check DSN**: Ensure `SENTRY_DSN` is set in environment variables
2. **Check environment**: Sentry is disabled in non-production builds
3. **Check logs**: Look for "Sentry disabled" message in console
4. **Verify initialization**: Ensure `Observability.initialize()` is called

### Events are missing context data

The context keys may not be in the allowlist. Add them to `_allowedContextKeys` in `sentry_observability_service.dart`.

### Clipboard content appearing in events

This should never happen due to our privacy controls. If it does:
1. Check that you're not adding clipboard content to breadcrumb/event data
2. Verify the `beforeSend` hook is active
3. Review and update the allowlist

## API Reference

### Observability Facade

```dart
class Observability {
  static void initialize(ObservabilityService service);
  static bool get isEnabled;
  
  static Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  });
  
  static Future<void> breadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    String? level,
  });
  
  static Future<void> message(
    String message, {
    String? level,
    Map<String, dynamic>? extras,
  });
  
  static Future<void> setUser(
    String userId, {
    String? email,
    Map<String, String>? extras,
  });
  
  static Future<void> clearUser();
  static Future<void> setTag(String key, String value);
  static Future<void> setContext(String key, Map<String, dynamic> value);
  static Future<void> close();
}
```

### Log Levels

- `debug`: Detailed debugging information
- `info`: General informational messages
- `warning`/`warn`: Warning messages
- `error`: Error messages
- `fatal`: Critical errors that cause app failure

## File Structure

```
lib/core/observability/
├── observability_service.dart           # Service interface
├── observability.dart                   # Static facade
├── observability_module.dart           # Barrel export
└── impl/
    └── sentry_observability_service.dart # Sentry implementation
```

## Next Steps

1. Add Sentry DSN to your environment configuration
2. Test error capture by triggering a test exception
3. Review breadcrumbs in Sentry dashboard
4. Gradually migrate print/log statements to breadcrumbs
5. Set up alerts in Sentry for critical errors

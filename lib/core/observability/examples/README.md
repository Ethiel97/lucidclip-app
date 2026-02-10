# Quick Start: Sentry Observability

## TL;DR

```dart
import 'package:lucid_clip/core/observability/observability_module.dart';

// Capture errors
try {
  await riskyOperation();
} catch (e, st) {
  await Observability.captureException(e, stackTrace: st);
}

// Add breadcrumbs
await Observability.breadcrumb('User clicked button', category: 'ui');

// Track user (on login)
await Observability.setUser(userId);

// Clear user (on logout)
await Observability.clearUser();
```

## Setup Checklist

- [x] ✅ Dependencies added to `pubspec.yaml`
- [x] ✅ Sentry initialized in `bootstrap.dart`
- [x] ✅ Service registered with Injectable
- [x] ✅ Facade available app-wide
- [ ] ⚠️ Configure `SENTRY_DSN` environment variable
- [ ] ⚠️ Run `flutter pub get`
- [ ] ⚠️ Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Environment Setup

Add to your dart-define configuration:

```bash
--dart-define=SENTRY_DSN=https://your-key@sentry.io/project-id
```

## Common Patterns

### 1. Error Handling in Cubits

```dart
class MyCubit extends Cubit<MyState> {
  Future<void> doSomething() async {
    try {
      final result = await _repository.fetch();
      emit(MyState.success(result));
    } catch (e, st) {
      await Observability.captureException(
        e,
        stackTrace: st,
        hint: {'action': 'fetch_data'},
      );
      emit(MyState.error());
    }
  }
}
```

### 2. User Actions (Breadcrumbs)

```dart
await Observability.breadcrumb(
  'User performed action',
  category: 'user_action',
  data: {
    'screen': 'home',
    'action': 'click_button',
  },
);
```

### 3. Privacy-Safe Clipboard Tracking

```dart
// ✅ GOOD: Metadata only
await Observability.breadcrumb(
  'Clipboard captured',
  category: 'clipboard',
  data: {
    'content_type': 'text',
    'content_length': 150,
  },
);

// ❌ NEVER: Actual content
// await Observability.breadcrumb(
//   'Clipboard captured',
//   data: {'content': clipboardText}, // DON'T!
// );
```

### 4. Auth State Changes

```dart
// On login
await Observability.setUser(user.id);
if (user.isPro) {
  await Observability.setTag('tier', 'pro');
}

// On logout
await Observability.clearUser();
```

## Privacy Rules

🚫 **NEVER** send:
- Clipboard contents
- User-entered text
- Passwords or tokens
- Email addresses (unless explicit consent)
- File contents

✅ **ALWAYS** send only:
- Metadata (length, type, format)
- Action names
- Categories
- Safe context (screen, platform, etc.)

## Testing

Sentry is **disabled** in development mode. To test:

1. Build in release mode: `flutter build <platform> --release`
2. Check Sentry dashboard for events
3. Or temporarily enable in `bootstrap.dart` for testing

## Troubleshooting

**No events in Sentry?**
- Check `SENTRY_DSN` is configured
- Verify `AppConstants.isProd` is true
- Look for "Sentry disabled" log message

**Missing context data?**
- Context keys must be in the allowlist
- Update `_allowedContextKeys` in `sentry_observability_service.dart`

## Full Documentation

See [SENTRY_INTEGRATION.md](../../../SENTRY_INTEGRATION.md) for complete documentation.

## Examples

See [cubit_examples.dart](cubit_examples.dart) for detailed code examples.

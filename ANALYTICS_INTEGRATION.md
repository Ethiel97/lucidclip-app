# Firebase Analytics Integration - LucidClip

This document describes the privacy-first analytics integration for LucidClip using Firebase Analytics.

## Overview

LucidClip uses Firebase Analytics with a strict privacy-first approach:

- ✅ **No clipboard content tracked** - Only metadata like item count, not actual data
- ✅ **No PII** - No usernames, emails, or identifying information
- ✅ **Environment-aware** - Disabled in debug/development, enabled only in staging/production
- ✅ **Minimal events** - Only 16 carefully selected events focused on product decisions
- ✅ **Dependency Injection** - Uses injectable for clean architecture and testability

## Architecture

### Core Components

```
lib/core/analytics/
├── analytics.dart                      # Global singleton entry point
├── analytics_service.dart              # Abstract service interface
├── firebase_analytics_service.dart     # Firebase Analytics implementation
├── analytics_events.dart               # Event names, enums, and typed helpers
├── retention_tracker.dart              # First launch & retention tracking
├── upgrade_source_mapper.dart          # Shared mapping utilities
└── analytics_module.dart               # Module exports

lib/core/feedback/
├── feedback_service.dart               # Abstract feedback service interface
├── wiredash_feedback_service.dart      # WireDash feedback implementation
└── feedback_module.dart                # Module exports
```

### Separation of Concerns

**Analytics (Firebase)**: Track user behavior, engagement, and product metrics
**Feedback (WireDash)**: Collect user feedback, bug reports, and feature requests

This separation ensures:

1. Each service has a single responsibility
2. Analytics and feedback can be configured independently
3. Easy to swap implementations without affecting the other
4. Clean dependency injection with injectable

### Key Design Principles

1. **Single Entry Point**: Use `Analytics.track()` everywhere
2. **Typed Parameters**: Use helper classes (e.g., `UpgradePromptShownParams`) to ensure consistency
3. **Privacy by Design**: All events are designed to exclude sensitive data
4. **Silent Failures**: Analytics errors never crash the app
5. **Dependency Injection**: Services registered via injectable for testability

## Configuration

### Dependencies

Firebase Analytics is already included in the project. The integration uses:

- `firebase_analytics` - For event tracking
- `firebase_core` - Already initialized in bootstrap
- `wiredash` - For user feedback (not analytics)

### Dependency Injection

Services are registered automatically via injectable:

```dart
// FirebaseAnalyticsService
@LazySingleton(as: AnalyticsService)
class FirebaseAnalyticsService implements AnalyticsService {
  ...
}

// WiredashFeedbackService
@LazySingleton(as: FeedbackService)
class WiredashFeedbackService implements FeedbackService {
  ...
}
```

### Initialization

Analytics is initialized in `bootstrap.dart` via dependency injection:

```dart
await configureDependencies();

// Initialize analytics service via DI
Analytics.initialize
(
getIt
<
AnalyticsService
>
(
)
);
```

The app wraps MaterialApp with Wiredash widget for feedback:

```dart
Wiredash
(
projectId: AppConstants.wiredashProjectId,
secret: AppConstants.wiredashSecret,
child: MaterialApp.router(...)
)
```

## Tracked Events

All 16 events remain the same as the original implementation:

### Activation Events (5)

| Event                                | Parameters | Tracked Where                                  |
|--------------------------------------|------------|------------------------------------------------|
| `app_first_launch`                   | None       | `RetentionTracker.trackAppOpened()`            |
| `permission_accessibility_requested` | None       | `AccessibilityCubit.requestPermission()`       |
| `permission_accessibility_granted`   | None       | `AccessibilityCubit.grantPermission()`         |
| `permission_accessibility_denied`    | None       | `AccessibilityCubit.cancelPermissionRequest()` |
| `clipboard_first_item_captured`      | None       | `ClipboardCubit._handleClipboardData()`        |

### Usage Events (5)

| Event                     | Parameters | Tracked Where                                       |
|---------------------------|------------|-----------------------------------------------------|
| `clipboard_item_captured` | None       | `ClipboardCubit._handleClipboardData()`             |
| `clipboard_item_used`     | None       | `ClipboardCubit._handleClipboardData()` (duplicate) |
| `pro_gate_overlay_opened` | None       | `ProGateOverlay` widget                             |
| `search_used`             | None       | `SearchCubit.search()`                              |
| `paste_to_app_used`       | None       | `PasteToAppService.pasteToApp()`                    |

### Monetization Events (5)

| Event                  | Parameters         | Tracked Where                                            |
|------------------------|--------------------|----------------------------------------------------------|
| `free_limit_reached`   | `limit_type: enum` | `LocalClipboardStoreImpl.upsertWithLimit()`              |
| `item_auto_deleted`    | `reason: enum`     | `RetentionCleanupServiceImpl`, `LocalClipboardStoreImpl` |
| `upgrade_prompt_shown` | `source: enum`     | `UpgradePromptListener`                                  |
| `upgrade_clicked`      | `source: enum`     | `UpgradePaywallSheet`                                    |
| `pro_activated`        | None               | `EntitlementCubit.boot()`                                |

### Retention Events (1)

| Event        | Parameters         | Tracked Where                       |
|--------------|--------------------|-------------------------------------|
| `app_opened` | `day_bucket: enum` | `RetentionTracker.trackAppOpened()` |

## Event Parameters

Same enums as before (LimitType, DeletionReason, UpgradeSource, DayBucket).

## Usage Examples

### Simple Event

```dart
await
Analytics.track
(
AnalyticsEvent
.
searchUsed
);
```

### Event with Parameters

```dart
await
Analytics.track
(
AnalyticsEvent.freeLimitReached,
FreeLimitReachedParams(limitType: LimitType.historySize)
.
toMap
(
)
,
);
```

### Event with Source Tracking

```dart
await
Analytics.track
(
AnalyticsEvent.upgradePromptShown,
UpgradePromptShownParams(source: UpgradeSource.limitHit)
.
toMap
(
)
,
);
```

## Firebase Analytics Features

### Event Name Sanitization

Firebase Analytics has naming restrictions:

- Event names must be <= 40 characters
- Can only contain alphanumeric characters and underscores
- Cannot start with a number

The `FirebaseAnalyticsService` automatically sanitizes event names to comply with these rules.

### Automatic Features

Firebase Analytics automatically provides:

- User properties and demographics
- Session tracking
- Screen view tracking
- Crash reporting integration
- Conversion tracking
- Audience segmentation

## Privacy Guarantees

### What We Track

✅ Event occurrences (e.g., "clipboard item captured")
✅ Coarse metadata (enums, booleans, counters)
✅ Anonymous user identifiers (hashed)
✅ Timing information (day buckets, not exact timestamps)

### What We DON'T Track

❌ Clipboard content or text
❌ File contents or paths
❌ User personal information (names, emails)
❌ Specific app names being used
❌ Exact search queries
❌ Precise usage timestamps

## Environment Control

Analytics is **disabled** by default in:

- Debug builds (`kDebugMode == true`)
- Development flavor

Analytics is **enabled** in:

- Staging flavor
- Production flavor
- Release builds (`kReleaseMode == true`)

## Firebase Console Setup

### Viewing Events

1. Go to Firebase Console → Analytics → Events
2. View real-time events in DebugView
3. Create custom reports and funnels
4. Set up conversion events

### Recommended Setup

1. **Mark conversion events**:
    - `clipboard_first_item_captured`
    - `pro_activated`
    - `permission_accessibility_granted`

2. **Create funnels**:
    - Activation: first_launch → permission_requested → permission_granted → first_item_captured
    - Conversion: upgrade_prompt_shown → upgrade_clicked → pro_activated

3. **Set up audiences**:
    - Active users: `app_opened` in last 7 days
    - Power users: `clipboard_item_captured` > 10/day
    - Conversion candidates: `free_limit_reached` without `pro_activated`

## Testing

### Debug Mode

Firebase Analytics can be tested in debug mode using the DebugView feature.

### Enable DebugView (macOS)

```bash
# Enable debug mode
adb shell setprop debug.firebase.analytics.app com.example.lucid_clip

# Or for iOS/macOS, add to scheme arguments:
-FIRDebugEnabled
```

Then view events in Firebase Console → DebugView.

## Feedback Service (WireDash)

WireDash is used separately for collecting user feedback:

```dart
// Get feedback service via DI
final feedbackService = getIt<FeedbackService>();

// Show feedback UI (requires BuildContext)
await
feedbackService.show
(
context);

// Set metadata
await feedbackService.setMetadata({
'user_type': 'pro',
'platform': 'macos',
});
```

## Migration from WireDash Analytics

The core analytics abstraction remains unchanged:

- Same `AnalyticsService` interface
- Same event names and parameters
- Same privacy guarantees
- Same instrumentation points

**Key changes**:

1. Backend changed from WireDash to Firebase Analytics
2. WireDash now used only for feedback
3. Services registered via dependency injection
4. Event names automatically sanitized for Firebase

## Best Practices

1. **Always use typed parameters** - Don't pass raw maps
2. **Check privacy** - Ensure no PII in event data
3. **Silent failures** - Never show analytics errors to users
4. **Test thoroughly** - Verify events fire in DebugView
5. **Document changes** - Update this file when modifying events
6. **Use DI** - Access services through getIt, not direct instantiation

## Support

For questions about:

- **Analytics implementation**: Check this documentation
- **Firebase Console**: Visit [Firebase documentation](https://firebase.google.com/docs/analytics)
- **Privacy concerns**: Review the privacy section above
- **WireDash feedback**: Visit [WireDash documentation](https://wiredash.com/docs)

## Changelog

### v2.0.0 - Firebase Analytics Migration

- Replaced WireDash analytics with Firebase Analytics
- Created separate FeedbackService for WireDash
- Implemented dependency injection for both services
- Maintained all 16 original events
- Updated documentation

### v1.0.0 - Initial WireDash Implementation

- Added 16 privacy-first analytics events
- Implemented WireDash integration
- Created typed event helpers and enums

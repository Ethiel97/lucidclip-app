# WireDash Analytics Integration - LucidClip

This document describes the privacy-first analytics integration for LucidClip using WireDash.

## Overview

LucidClip uses WireDash for analytics with a strict privacy-first approach:

- ✅ **No clipboard content tracked** - Only metadata like item count, not actual data
- ✅ **No PII** - No usernames, emails, or identifying information
- ✅ **Environment-aware** - Disabled in debug/development, enabled only in staging/production
- ✅ **Minimal events** - Only 16 carefully selected events focused on product decisions

## Architecture

### Core Components

```
lib/core/analytics/
├── analytics.dart                      # Global singleton entry point
├── analytics_service.dart              # Abstract service interface
├── wiredash_analytics_service.dart     # WireDash implementation
├── analytics_events.dart               # Event names, enums, and typed helpers
├── retention_tracker.dart              # First launch & retention tracking
└── analytics_module.dart               # Module exports
```

### Key Design Principles

1. **Single Entry Point**: Use `Analytics.track()` everywhere
2. **Typed Parameters**: Use helper classes (e.g., `UpgradePromptShownParams`) to ensure consistency
3. **Privacy by Design**: All events are designed to exclude sensitive data
4. **Silent Failures**: Analytics errors never crash the app

## Configuration

### Environment Variables

Add to your `.env` or `dart_defines.json`:

```json
{
  "WIREDASH_PROJECT_ID": "your-project-id",
  "WIREDASH_SECRET": "your-secret-key"
}
```

### Initialization

Analytics is initialized in `bootstrap.dart`:

```dart
Analytics.initialize(
  WireDashAnalyticsService(
    wiredashProjectId: AppConstants.wiredashProjectId,
    wiredashSecret: AppConstants.wiredashSecret,
    enabledInDebug: false, // Disabled in debug mode
  ),
);
```

The app is wrapped with Wiredash widget in `app.dart`:

```dart
Wiredash(
  projectId: AppConstants.wiredashProjectId,
  secret: AppConstants.wiredashSecret,
  child: MaterialApp.router(...)
)
```

## Tracked Events

### Activation Events (5)

| Event | Parameters | Tracked Where |
|-------|-----------|---------------|
| `app_first_launch` | None | `RetentionTracker.trackAppOpened()` |
| `permission_accessibility_requested` | None | `AccessibilityCubit.requestPermission()` |
| `permission_accessibility_granted` | None | `AccessibilityCubit.grantPermission()` |
| `permission_accessibility_denied` | None | `AccessibilityCubit.cancelPermissionRequest()` |
| `clipboard_first_item_captured` | None | `ClipboardCubit._handleClipboardData()` |

### Usage Events (5)

| Event | Parameters | Tracked Where |
|-------|-----------|---------------|
| `clipboard_item_captured` | None | `ClipboardCubit._handleClipboardData()` |
| `clipboard_item_used` | None | `ClipboardCubit._handleClipboardData()` (duplicate) |
| `overlay_opened` | None | `ProGateOverlay` widget |
| `search_used` | None | `SearchCubit.search()` |
| `paste_to_app_used` | None | `PasteToAppService.pasteToApp()` |

### Monetization Events (5)

| Event | Parameters | Tracked Where |
|-------|-----------|---------------|
| `free_limit_reached` | `limit_type: enum` | `LocalClipboardStoreImpl.upsertWithLimit()` |
| `item_auto_deleted` | `reason: enum` | `RetentionCleanupServiceImpl`, `LocalClipboardStoreImpl` |
| `upgrade_prompt_shown` | `source: enum` | `UpgradePromptListener` |
| `upgrade_clicked` | `source: enum` | `UpgradePaywallSheet` |
| `pro_activated` | None | `EntitlementCubit.boot()` |

### Retention Events (1)

| Event | Parameters | Tracked Where |
|-------|-----------|---------------|
| `app_opened` | `day_bucket: enum` | `RetentionTracker.trackAppOpened()` |

## Event Parameters

### Enums

**LimitType** (for `free_limit_reached`):
- `history_size` - History limit reached
- `retention` - Retention limit reached
- `excluded_apps` - Excluded apps limit reached

**DeletionReason** (for `item_auto_deleted`):
- `retention` - Deleted due to retention policy
- `manual_cleanup` - Deleted due to history limit cleanup

**UpgradeSource** (for `upgrade_prompt_shown` and `upgrade_clicked`):
- `limit_hit` - Triggered when free limit is reached
- `settings` - Triggered from settings or account page
- `banner` - Triggered from a banner
- `pro_gate` - Triggered from pro-gated feature (pin, ignored apps, etc.)

**DayBucket** (for `app_opened`):
- `d0` - First day (day 0)
- `d1` - Second day (day 1)
- `d7` - Days 2-7
- `d30` - Day 8+

## Usage Examples

### Simple Event

```dart
await Analytics.track(AnalyticsEvent.searchUsed);
```

### Event with Parameters

```dart
await Analytics.track(
  AnalyticsEvent.freeLimitReached,
  FreeLimitReachedParams(limitType: LimitType.historySize).toMap(),
);
```

### Event with Source Tracking

```dart
await Analytics.track(
  AnalyticsEvent.upgradePromptShown,
  UpgradePromptShownParams(source: UpgradeSource.limitHit).toMap(),
);
```

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

To override in debug mode (for testing):

```dart
Analytics.initialize(
  WireDashAnalyticsService(
    wiredashProjectId: AppConstants.wiredashProjectId,
    wiredashSecret: AppConstants.wiredashSecret,
    enabledInDebug: true, // Enable for testing
  ),
);
```

## Testing Analytics

### Check if Analytics is Enabled

```dart
if (Analytics.isEnabled) {
  print('Analytics is enabled');
}
```

### Testing in Debug Mode

By default, analytics is disabled in debug mode. To test:

1. Set `enabledInDebug: true` in bootstrap.dart
2. Trigger events in the app
3. Check WireDash dashboard for events
4. Remember to set back to `false` before committing

### Testing Events

Each event is triggered at specific points in the user flow:

1. **First Launch**: Open app for the first time
2. **Permission Events**: Request and grant/deny accessibility permission
3. **Clipboard Events**: Copy items to clipboard
4. **Search Events**: Use the search functionality
5. **Upgrade Events**: Trigger pro-gated features or click upgrade buttons

## Security Considerations

### API Keys

- Store WireDash credentials in environment variables
- Never commit API keys to version control
- Use different projects for staging and production

### Data Retention

- Events are stored in WireDash's secure infrastructure
- Review WireDash's privacy policy and GDPR compliance
- Configure data retention policies in WireDash dashboard

### User Privacy

- No PII is collected
- Events are designed to be privacy-preserving
- Analytics can be disabled if needed for compliance

## Troubleshooting

### Events Not Appearing

1. Check that analytics is enabled: `Analytics.isEnabled`
2. Verify WireDash credentials in AppConstants
3. Ensure you're in staging/production mode, not debug
4. Check for errors in console (analytics failures are logged but silent)

### Debug Mode Issues

If you need to test analytics in debug mode:
- Set `enabledInDebug: true` temporarily
- Remember to revert before committing

### Missing Events

If events aren't firing:
1. Check the instrumentation point is being reached
2. Verify the event name matches `AnalyticsEvent` constants
3. Ensure parameters are correctly formatted with `.toMap()`

## Migration & Updates

### Adding New Events

1. Add event name to `AnalyticsEvent` class
2. Create parameter class if needed (e.g., `MyEventParams`)
3. Add enum values if needed
4. Instrument the event at the appropriate location
5. Update this documentation

### Removing Events

1. Remove instrumentation calls
2. Deprecate (don't remove) event names for backward compatibility
3. Update documentation

## Best Practices

1. **Always use typed parameters** - Don't pass raw maps
2. **Check privacy** - Ensure no PII in event data
3. **Silent failures** - Never show analytics errors to users
4. **Test thoroughly** - Verify events fire in staging before production
5. **Document changes** - Update this file when modifying events

## Support

For questions about:
- **Analytics implementation**: Check this documentation
- **WireDash dashboard**: Visit [WireDash documentation](https://wiredash.com/docs)
- **Privacy concerns**: Review the privacy section above

## Changelog

### v1.0.0 - Initial Implementation
- Added 16 privacy-first analytics events
- Implemented WireDash integration
- Created typed event helpers and enums
- Added environment-based enabling/disabling
- Instrumented all events throughout the app

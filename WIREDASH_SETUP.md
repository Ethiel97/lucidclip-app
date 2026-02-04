# WireDash Setup Guide for LucidClip

This guide walks through setting up WireDash analytics for LucidClip.

## Prerequisites

- Access to [WireDash Console](https://console.wiredash.com)
- LucidClip development environment set up

## Step 1: Create WireDash Project

1. Go to [WireDash Console](https://console.wiredash.com)
2. Create a new project or use existing one
3. Note your **Project ID** and **Secret Key**

## Step 2: Configure Environment Variables

### For Local Development

Add to `.env` file in the project root:

```bash
WIREDASH_PROJECT_ID=your_wiredash_project_id
WIREDASH_SECRET=your_wiredash_secret_key
```

### For CI/CD (GitHub Actions)

Add to GitHub repository secrets:

1. Go to repository Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `WIREDASH_PROJECT_ID`
   - `WIREDASH_SECRET`

### For Flutter Builds

When building with flavors, pass via `dart_defines.json`:

```json
{
  "WIREDASH_PROJECT_ID": "your_project_id",
  "WIREDASH_SECRET": "your_secret"
}
```

Then build with:

```bash
flutter build macos --flavor production \
  -t lib/main_production.dart \
  --dart-define-from-file=dart_defines.json
```

## Step 3: Verify Integration

### Test in Debug Mode

By default, analytics is disabled in debug mode. To test:

1. Edit `lib/bootstrap.dart`
2. Temporarily set `enabledInDebug: true`:

```dart
Analytics.initialize(
  WireDashAnalyticsService(
    wiredashProjectId: AppConstants.wiredashProjectId,
    wiredashSecret: AppConstants.wiredashSecret,
    enabledInDebug: true, // Enable for testing
  ),
);
```

3. Run the app: `flutter run -d macos`
4. Trigger some events (open app, search, etc.)
5. Check WireDash dashboard for incoming events
6. **Important**: Revert `enabledInDebug` back to `false`

### Test in Release Mode

Build a release version:

```bash
flutter build macos --flavor production \
  -t lib/main_production.dart \
  --dart-define-from-file=dart_defines.json
```

Run and verify events appear in WireDash dashboard.

## Step 4: Configure WireDash Dashboard

### Event Tracking

WireDash will automatically receive the following events:

**Activation** (5 events):
- app_first_launch
- permission_accessibility_requested
- permission_accessibility_granted
- permission_accessibility_denied
- clipboard_first_item_captured

**Usage** (5 events):
- clipboard_item_captured
- clipboard_item_used
- overlay_opened
- search_used
- paste_to_app_used

**Monetization** (5 events):
- free_limit_reached
- item_auto_deleted
- upgrade_prompt_shown
- upgrade_clicked
- pro_activated

**Retention** (1 event):
- app_opened

### Dashboard Setup

1. **Create Funnels** for user activation:
   - First Launch → Permission Requested → Permission Granted → First Item Captured

2. **Track Retention** with app_opened day buckets:
   - Filter by day_bucket: d0, d1, d7, d30

3. **Monitor Conversion**:
   - Track upgrade_prompt_shown → upgrade_clicked → pro_activated

4. **Usage Metrics**:
   - Monitor clipboard_item_captured frequency
   - Track search_used adoption
   - Measure paste_to_app_used engagement

## Step 5: Different Environments

### Recommended Setup

Create separate WireDash projects for different environments:

1. **Development**: For local testing (if needed)
2. **Staging**: For QA and pre-production testing
3. **Production**: For live app analytics

Configure via flavor-specific environment files or CI/CD secrets.

## Troubleshooting

### No Events Appearing

**Check 1**: Verify analytics is enabled
```dart
print('Analytics enabled: ${Analytics.isEnabled}');
```

**Check 2**: Verify credentials are loaded
```dart
print('WireDash Project ID: ${AppConstants.wiredashProjectId}');
// Should NOT print the actual secret in production!
```

**Check 3**: Check for errors in console
Look for lines starting with "Analytics error"

**Check 4**: Ensure you're not in debug mode
Analytics is disabled by default in debug mode.

### Events Not Tracked in Debug

This is expected behavior for privacy. To enable:
- Set `enabledInDebug: true` in bootstrap.dart (temporarily)
- Or build in release mode

### Missing Credentials

Error: `WIREDASH_PROJECT_ID` or `WIREDASH_SECRET` is empty

**Solution**: 
1. Verify `.env` file exists in project root
2. Check environment variables are set correctly
3. For CI/CD, verify GitHub secrets are configured

## Privacy & GDPR

WireDash is GDPR compliant. Key points:

- ✅ No PII is tracked (see ANALYTICS_INTEGRATION.md)
- ✅ All events are privacy-preserving
- ✅ No clipboard content or text is sent
- ✅ User IDs are hashed/anonymous

Configure data retention in WireDash dashboard settings.

## Support Resources

- [WireDash Documentation](https://wiredash.com/docs)
- [WireDash Console](https://console.wiredash.com)
- Project Documentation: See `ANALYTICS_INTEGRATION.md`

## Next Steps

After setup:

1. ✅ Verify events are flowing to WireDash
2. ✅ Set up key funnels and dashboards
3. ✅ Configure alerts for important metrics
4. ✅ Review privacy compliance
5. ✅ Document any custom events or changes

## Questions?

See `ANALYTICS_INTEGRATION.md` for detailed documentation on:
- Event definitions and parameters
- Privacy guarantees
- Usage examples
- Best practices

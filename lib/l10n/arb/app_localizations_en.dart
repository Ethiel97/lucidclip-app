// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get account => 'Account';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get allTypes => 'All Types';

  @override
  String appExcludedFromTracking(String appName) {
    return '$appName excluded from tracking';
  }

  @override
  String appIncludedInTracking(String appName) {
    return '$appName included in tracking';
  }

  @override
  String get appName => 'LucidClip';

  @override
  String appNoLongerTracked(String appName) {
    return '$appName no longer tracked';
  }

  @override
  String appNoLongerTrackedDescription(String appName) {
    return 'ClipboardItem from $appName will no longer be saved. You can change this in the Settings.';
  }

  @override
  String get appTagLine => 'LucidClip - Your clipboard, finally under control.';

  @override
  String get appearance => 'Appearance';

  @override
  String get appendToClipboard => 'Append to Clipboard';

  @override
  String get paste => 'Paste';

  @override
  String get pasteTo => 'Paste to';

  @override
  String appsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
      zero: 'No apps',
    );
    return '$_temp0';
  }

  @override
  String get appsIgnoredDuringClipboardTracking =>
      'Apps ignored during clipboard tracking';

  @override
  String get appsNotTrackedDuringClipboardTracking =>
      'Apps not tracked during clipboard tracking';

  @override
  String get authenticationError => 'Authentication Error';

  @override
  String get autoSync => 'Auto Sync';

  @override
  String get autoSyncDescription =>
      'Syncs the clipboard with the server automatically.';

  @override
  String get autoSyncInterval => 'Auto Sync Interval';

  @override
  String get autoSyncIntervalDescription =>
      'Sets how often the clipboard is synced with the server.';

  @override
  String get build => 'Build';

  @override
  String get cancel => 'Cancel';

  @override
  String get characters => 'Characters';

  @override
  String get chooseYourAppTheme => 'Choose your app theme';

  @override
  String get chooseYourAppThemeDescription => 'Choose your preferred theme.';

  @override
  String get chooseYourClipboardThemeDescription =>
      'Choose your preferred color scheme.';

  @override
  String get clearClipboardHistory => 'Clear Clipboard History';

  @override
  String get clearClipboardShortcut => 'Clear Clipboard';

  @override
  String get clearClipboardShortcutDescription => 'Clear all clipboard history';

  @override
  String get clipboard => 'Clipboard';

  @override
  String pasteToApp(String appName) {
    return 'Paste to $appName';
  }

  @override
  String get clipboardCaptureStarted => 'Clipboard capture started';

  @override
  String get clipboardFull => 'Clipboard full!';

  @override
  String get clipboardFullDescription =>
      'Your clipboard has reached its storage limit. Older items will be replaced by new copies.';

  @override
  String get clipboardHistory => 'Clipboard History';

  @override
  String get code => 'Code';

  @override
  String get command => 'Command';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get copied => 'Copied';

  @override
  String copiedToClipboard(String item) {
    return '$item copied to clipboard';
  }

  @override
  String get copy => 'Copy';

  @override
  String get copyLastItem => 'Copy last item';

  @override
  String get copyPath => 'Copy path';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get dark => 'Dark';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: '0 day',
    );
    return '$_temp0';
  }

  @override
  String get delete => 'Delete';

  @override
  String get clipContent => 'Clip content';

  @override
  String get edit => 'Edit';

  @override
  String get editShortcut => 'Edit Shortcut';

  @override
  String get email => 'Email';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get errorOccurred => 'An error occurred. Please try again later.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get exclude => 'Exclude';

  @override
  String get excluded => 'Excluded';

  @override
  String get failedToLoadLinkPreview => 'Failed to load link preview';

  @override
  String get failedToOpenUrl => 'Failed to open URL';

  @override
  String get fifteenMinutes => '15 Minutes';

  @override
  String get fileOnly => 'File Only';

  @override
  String get format => 'Format';

  @override
  String get free => 'Free';

  @override
  String get freeSubscription => 'Free';

  @override
  String get general => 'General';

  @override
  String get github => 'GitHub';

  @override
  String get hideWindow => 'Hide Window';

  @override
  String get history => 'History';

  @override
  String get historyLimit => 'History Limit';

  @override
  String get ignorePasswords => 'Ignore Copied Passwords';

  @override
  String get ignored => 'Ignored';

  @override
  String get ignoredApps => 'Ignored Apps';

  @override
  String get ignoredAppsDescription => 'Apps ignored during clipboard tracking';

  @override
  String get imageOnly => 'Image Only';

  @override
  String get include => 'Include';

  @override
  String includeApp(String appName) {
    return 'Include $appName';
  }

  @override
  String includeAppConfirmation(String appName) {
    return 'Include $appName in clipboard tracking?';
  }

  @override
  String get incognitoMode => 'Incognito Mode';

  @override
  String get incognitoModeDescription =>
      'Disables history recording for copied items.';

  @override
  String get information => 'Information';

  @override
  String get itemDetails => 'Item Details';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get light => 'Light';

  @override
  String get link => 'Link';

  @override
  String get linkOnly => 'Link Only';

  @override
  String get loadSubscriptionPortal => 'Load subscription portal';

  @override
  String get loadingLinkPreview => 'Loading link preview...';

  @override
  String get manageRetention => 'Manage Retention';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String get maxHistoryItemsDescription =>
      'Sets how much history LucidClip can safely retain.';

  @override
  String get maxHistorySize => 'Maximum history size';

  @override
  String minutesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
      zero: '0 minute',
    );
    return '$_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
      zero: '0 month',
    );
    return '$_temp0';
  }

  @override
  String get noAppsAreCurrentlyIgnored => 'No apps are currently ignored.';

  @override
  String get noClipboardHistory => 'No clipboard history';

  @override
  String noItemsForCategory(String category) {
    return 'No $category items';
  }

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noSettingsAvailable => 'No settings available';

  @override
  String get none => 'None';

  @override
  String get notAvailable => 'Not available';

  @override
  String get notSet => 'Not set';

  @override
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get oldItemsWillBeOverwritten =>
      'Old items will be overwritten. Go pro to keep everything.';

  @override
  String get oneHour => '1 Hour';

  @override
  String get openLink => 'Open link';

  @override
  String get pauseTracking => 'Pause Tracking';

  @override
  String get pin => 'Pin';

  @override
  String get pinned => 'Pinned';

  @override
  String get pressKeyCombination => 'Press key combination...';

  @override
  String get preview => 'Preview';

  @override
  String get previewImages => 'Preview Images';

  @override
  String get previewImagesDescription =>
      'Shows a preview of images in the clipboard.';

  @override
  String get previewLinks => 'Preview Links';

  @override
  String get previewLinksDescription =>
      'Shows a preview of links in the clipboard.';

  @override
  String get privacy => 'Privacy';

  @override
  String get privateSessionDuration => 'Private Session Duration';

  @override
  String get pro => 'Pro';

  @override
  String get proFeatureAutoSync => 'Auto sync across devices';

  @override
  String get proFeatureAutoSyncDescription =>
      'Keeps your clipboard in sync across devices (opt-in).';

  @override
  String get proFeatureExtendedRetentionDays => 'Extended Retention Days';

  @override
  String get proFeatureExtendedRetentionDaysDescription =>
      'Keep your history for up to one year.';

  @override
  String get proFeatureIgnoredApps => 'Ignore apps for privacy';

  @override
  String get proFeatureIgnoredAppsDescription =>
      'Exclude apps from clipboard tracking.';

  @override
  String get proFeaturePinItems => 'Pin important clips';

  @override
  String get proFeaturePinItemsDescription =>
      'Keep important items forever. Pinned clips are never removed';

  @override
  String get proFeatureUnlimitedHistory => 'Unlimited history';

  @override
  String get proFeatureUnlimitedHistoryDescription =>
      'Never lose clips. Your history grows with you.';

  @override
  String get proSubscription => 'Pro';

  @override
  String get quit => 'Quit';

  @override
  String get recent => 'Recent';

  @override
  String get redirectingToSecureCheckout => 'Redirecting to secure checkout...';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get resumeClipboardCapture => 'Resume clipboard capture';

  @override
  String get resumeTracking => 'Resume Tracking';

  @override
  String resumeTrackingApp(String appName) {
    return 'Resume tracking $appName';
  }

  @override
  String resumeTrackingAppConfirmation(Object appName) {
    return 'Resume clipboard tracking for $appName?';
  }

  @override
  String get retentionDays => 'Retention Days';

  @override
  String get retentionDaysDescription =>
      'Sets how long items are kept in the clipboard.';

  @override
  String get retentionExpired => 'Expired';

  @override
  String retentionExpiresIn(int value, String unit) {
    return 'Auto-Removed in $value $unit';
  }

  @override
  String get retry => 'Retry';

  @override
  String get searchClipboardShortcut => 'Search Clipboard';

  @override
  String get searchClipboardShortcutDescription =>
      'Open window and focus search';

  @override
  String get searchHint => 'Search...';

  @override
  String get settings => 'Settings';

  @override
  String get share => 'Share';

  @override
  String get shortcutConflict => 'Shortcut already in use';

  @override
  String get shortcuts => 'Shortcuts';

  @override
  String get shortcutsDescription =>
      'Configure global keyboard shortcuts for quick actions';

  @override
  String get showHideWindow => 'Show/Hide Window';

  @override
  String get showInMenuBar => 'Show in Menu Bar';

  @override
  String get showSourceApp => 'Show Source App';

  @override
  String get showSourceAppDescription =>
      'Shows the app that copied the content to the clipboard in the item details.';

  @override
  String get showWindow => 'Show Window';

  @override
  String get showWindowShortcut => 'Show Window';

  @override
  String get showWindowShortcutDescription =>
      'Bring the application window to focus';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInToViewAccount => 'Sign in to view account information';

  @override
  String signInWith(String provider) {
    return 'Sign in with $provider';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get signedInSuccessfully => 'Signed in successfully!';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get size => 'Size';

  @override
  String get snippet => 'Snippet';

  @override
  String get snippets => 'Snippets';

  @override
  String get source => 'Source';

  @override
  String get startPrivateSession => 'Start Private Session';

  @override
  String get stopClipboardCapture => 'Stop clipboard capture';

  @override
  String stopTrackingApp(String appName) {
    return 'Stop tracking $appName';
  }

  @override
  String stopTrackingAppConfirmation(String appName) {
    return 'LucidClip will no longer save clipboard items copied from $appName.';
  }

  @override
  String get storage => 'Storage';

  @override
  String get storageAlmostFull => 'Storage almost full!';

  @override
  String storageAlmostFullDescription(int count) {
    return 'You\'re using $count% of your clipboard history.';
  }

  @override
  String get subscription => 'Subscription';

  @override
  String get subscriptionType => 'Subscription Type';

  @override
  String get successfullySignedIn => 'Successfully signed in!';

  @override
  String get successfullySignedOut => 'Successfully signed out!';

  @override
  String get sync => 'Sync';

  @override
  String get syncInterval => 'Sync Interval';

  @override
  String get syncIntervalDescription =>
      'Sets how often the clipboard is synced with the server.';

  @override
  String get system => 'System';

  @override
  String get tags => 'Tags';

  @override
  String get textOnly => 'Text Only';

  @override
  String get theme => 'Theme';

  @override
  String get toggleIncognitoShortcut => 'Toggle Incognito Mode (Shortcut)';

  @override
  String get toggleIncognitoShortcutDescription =>
      'Enable or disable incognito mode';

  @override
  String get toggleWindowShortcut => 'Toggle window (Shortcut)';

  @override
  String get toggleWindowShortcutDescription => 'Show or hide LucidClip';

  @override
  String get trackingPreferencesUpdated => 'Tracking preferences updated!';

  @override
  String trackingResumedForApp(String appName) {
    return 'Tracking resumed for $appName';
  }

  @override
  String trackingResumedForAppDescription(String appName) {
    return 'Clipboard items from $appName will now appear in your history.';
  }

  @override
  String get unlimited => 'Unlimited';

  @override
  String get unpin => 'Unpin';

  @override
  String get untilDisabled => 'Until Disabled';

  @override
  String get upgradePaywallSheetFooterSubtitle =>
      'Local-first by default. No cloud unless you enable it.';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get usage => 'Usage';

  @override
  String get validUntil => 'Valid Until';

  @override
  String get version => 'Version';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
      zero: '0 week',
    );
    return '$_temp0';
  }

  @override
  String get welcomeToPro => 'Welcome to Pro 🎉!';

  @override
  String yearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
      zero: '0 year',
    );
    return '$_temp0';
  }

  @override
  String get youCanIncreaseYouStorageLimitWithYourProPlan =>
      'You can increase your storage limit with your Pro plan.';

  @override
  String get youNowHavePro => 'You now have access to all Pro features.';

  @override
  String get yourClipboardHistoryIsLimited =>
      'Your clipboard history is limited. Go Pro to keep everything.';

  @override
  String get yourClipboardItemsWillAppearHere =>
      'Your clipboard items will appear here.';
}

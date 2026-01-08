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
  String get appTagLine => 'A smarter clipboard. On your terms';

  @override
  String get appearance => 'Appearance';

  @override
  String get appendToClipboard => 'Append to Clipboard';

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
  String get clipboard => 'Clipboard';

  @override
  String get clipboardCaptureStarted => 'Clipboard capture started';

  @override
  String get clipboardHistory => 'Clipboard History';

  @override
  String get code => 'Code';

  @override
  String get command => 'Command';

  @override
  String get confirm => 'Confirm';

  @override
  String get copied => 'Copied';

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
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get errorOccurred => 'An error occurred. Please try again later.';

  @override
  String get exclude => 'Exclude';

  @override
  String get excluded => 'Excluded';

  @override
  String get failedToLoadLinkPreview => 'Failed to load link preview';

  @override
  String get fifteenMinutes => '15 Minutes';

  @override
  String get fileOnly => 'File Only';

  @override
  String get format => 'Format';

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
  String get loadingLinkPreview => 'Loading link preview...';

  @override
  String get maxHistoryItemsDescription =>
      'Sets the maximum number of items in the clipboard.';

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
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

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
  String get privateSessionDuration => 'Private Session Duration';

  @override
  String get quit => 'Quit';

  @override
  String get recent => 'Recent';

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
  String get retry => 'Retry';

  @override
  String get searchHint => 'Search...';

  @override
  String get settings => 'Settings';

  @override
  String get share => 'Share';

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
  String get signIn => 'Sign in';

  @override
  String signInWith(String provider) {
    return 'Sign in with $provider';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get size => 'Size';

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
  String trackingResumedForApp(String appName) {
    return 'Tracking resumed for $appName';
  }

  @override
  String trackingResumedForAppDescription(String appName) {
    return 'Clipboard items from $appName will now appear in your history.';
  }

  @override
  String get unpin => 'Unpin';

  @override
  String get untilDisabled => 'Until Disabled';

  @override
  String get version => 'Version';

  @override
  String get yourClipboardItemsWillAppearHere =>
      'Your clipboard items will appear here.';
}

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
  String get appName => 'LucidClip';

  @override
  String get appearance => 'Appearance';

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
  String get characters => 'Characters';

  @override
  String get chooseYourAppTheme => 'Choose your app theme';

  @override
  String get chooseYourAppThemeDescription => 'Choose your preferred theme.';

  @override
  String get chooseYourClipboardThemeDescription =>
      'Choose your preferred color scheme.';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get code => 'Code';

  @override
  String get command => 'Command';

  @override
  String get copied => 'Copied';

  @override
  String get copy => 'Copy';

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
  String get failedToLoadLinkPreview => 'Failed to load link preview';

  @override
  String get fileOnly => 'File Only';

  @override
  String get format => 'Format';

  @override
  String get general => 'General';

  @override
  String get history => 'History';

  @override
  String get historyLimit => 'History Limit';

  @override
  String get ignorePasswords => 'Ignore Copied Passwords';

  @override
  String get imageOnly => 'Image Only';

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
  String noItemsForCategory(String category) {
    return 'No $category items';
  }

  @override
  String get noSettingsAvailable => 'No settings available';

  @override
  String get notifications => 'Notifications';

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
  String get recent => 'Recent';

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
  String get showInMenuBar => 'Show in Menu Bar';

  @override
  String get showSourceApp => 'Show Source App';

  @override
  String get showSourceAppDescription =>
      'Shows the app that copied the content.';

  @override
  String get size => 'Size';

  @override
  String get snippets => 'Snippets';

  @override
  String get source => 'Source';

  @override
  String get storage => 'Storage';

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
  String get unpin => 'Unpin';

  @override
  String get version => 'Version';
}

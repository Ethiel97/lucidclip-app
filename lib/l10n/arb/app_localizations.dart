import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Label for the About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for the All Types filter
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// Label for an app that is excluded from tracking
  ///
  /// In en, this message translates to:
  /// **'{appName} excluded from tracking'**
  String appExcludedFromTracking(String appName);

  /// Label for an app that is included in tracking
  ///
  /// In en, this message translates to:
  /// **'{appName} included in tracking'**
  String appIncludedInTracking(String appName);

  /// Name of the app
  ///
  /// In en, this message translates to:
  /// **'LucidClip'**
  String get appName;

  /// Message shown when an app is no longer tracked
  ///
  /// In en, this message translates to:
  /// **'{appName} no longer tracked'**
  String appNoLongerTracked(String appName);

  /// Description shown when an app is no longer tracked
  ///
  /// In en, this message translates to:
  /// **'ClipboardItem from {appName} will no longer be saved. You can change this in the Settings.'**
  String appNoLongerTrackedDescription(String appName);

  /// Tagline for the app
  ///
  /// In en, this message translates to:
  /// **'LucidClip - Your clipboard, finally under control.'**
  String get appTagLine;

  /// Label for the Appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Button text to append content to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Append to Clipboard'**
  String get appendToClipboard;

  /// Label showing the number of apps with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No apps} =1 {1 app} other {apps}}'**
  String appsCount(int count);

  /// Title for the Apps Ignored During Clipboard Tracking section
  ///
  /// In en, this message translates to:
  /// **'Apps ignored during clipboard tracking'**
  String get appsIgnoredDuringClipboardTracking;

  /// Title for the Apps Not Tracked During Clipboard Tracking section
  ///
  /// In en, this message translates to:
  /// **'Apps not tracked during clipboard tracking'**
  String get appsNotTrackedDuringClipboardTracking;

  /// Error message shown when authentication fails
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get authenticationError;

  /// Label for the Auto Sync setting
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// Description for the Auto Sync setting
  ///
  /// In en, this message translates to:
  /// **'Syncs the clipboard with the server automatically.'**
  String get autoSyncDescription;

  /// Label for the Auto Sync Interval setting
  ///
  /// In en, this message translates to:
  /// **'Auto Sync Interval'**
  String get autoSyncInterval;

  /// Description for the Auto Sync Interval setting
  ///
  /// In en, this message translates to:
  /// **'Sets how often the clipboard is synced with the server.'**
  String get autoSyncIntervalDescription;

  /// Label for the app build number
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// Button text to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for the number of characters
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// Label for the Theme settings
  ///
  /// In en, this message translates to:
  /// **'Choose your app theme'**
  String get chooseYourAppTheme;

  /// Description for the Theme settings
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme.'**
  String get chooseYourAppThemeDescription;

  /// Description for the Theme settings
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred color scheme.'**
  String get chooseYourClipboardThemeDescription;

  /// Tray menu item to clear all clipboard history
  ///
  /// In en, this message translates to:
  /// **'Clear Clipboard History'**
  String get clearClipboardHistory;

  /// Label for the Clipboard feature
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboard;

  /// Message shown when clipboard capture has started
  ///
  /// In en, this message translates to:
  /// **'Clipboard capture started'**
  String get clipboardCaptureStarted;

  /// Tray menu item for clipboard history submenu
  ///
  /// In en, this message translates to:
  /// **'Clipboard History'**
  String get clipboardHistory;

  /// Label for Code input
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// Label for Command input
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get command;

  /// Button text to confirm an action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Message shown when content is copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Button text to copy content
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Button text to copy the last item to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy last item'**
  String get copyLastItem;

  /// Button text to copy the path of a file
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get copyPath;

  /// Button text to copy content to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// Text shown in the AppBar of the Counter Page
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterAppBarTitle;

  /// Name of the dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Button text to delete content
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button text to edit content
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Error message shown when settings cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// Error message shown when an error occurs
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later.'**
  String get errorOccurred;

  /// Button text to exclude an app from tracking
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get exclude;

  /// Label for the Excluded feature
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get excluded;

  /// Message shown when the preview failed to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load link preview'**
  String get failedToLoadLinkPreview;

  /// Duration option: 15 minutes
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get fifteenMinutes;

  /// Label for the File Only filter
  ///
  /// In en, this message translates to:
  /// **'File Only'**
  String get fileOnly;

  /// Label for the format of the content
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// Name of the free plan
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Label for the General settings
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// Tray menu item to hide the window
  ///
  /// In en, this message translates to:
  /// **'Hide Window'**
  String get hideWindow;

  /// Title for the History Page
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Label for the History Limit setting
  ///
  /// In en, this message translates to:
  /// **'History Limit'**
  String get historyLimit;

  /// Label for the Ignore Copied Passwords setting
  ///
  /// In en, this message translates to:
  /// **'Ignore Copied Passwords'**
  String get ignorePasswords;

  /// Label for the Ignored Apps settings
  ///
  /// In en, this message translates to:
  /// **'Ignored Apps'**
  String get ignoredApps;

  /// Description for the Ignored Apps settings
  ///
  /// In en, this message translates to:
  /// **'Apps ignored during clipboard tracking'**
  String get ignoredAppsDescription;

  /// Label for the Image Only filter
  ///
  /// In en, this message translates to:
  /// **'Image Only'**
  String get imageOnly;

  /// Button text to include an app in tracking
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get include;

  /// Label for the Include App setting
  ///
  /// In en, this message translates to:
  /// **'Include {appName}'**
  String includeApp(String appName);

  /// Confirmation dialog shown when including an app in clipboard tracking
  ///
  /// In en, this message translates to:
  /// **'Include {appName} in clipboard tracking?'**
  String includeAppConfirmation(String appName);

  /// Label for the Incognito Mode setting
  ///
  /// In en, this message translates to:
  /// **'Incognito Mode'**
  String get incognitoMode;

  /// Description for the Incognito Mode setting
  ///
  /// In en, this message translates to:
  /// **'Disables history recording for copied items.'**
  String get incognitoModeDescription;

  /// Label for the information section
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// Title for the Item Details Panel
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemDetails;

  /// Label showing the number of items with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No items} =1 {1 item} other {{count} items}}'**
  String itemsCount(int count);

  /// Name of the light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Label for Link input
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// Label for the Link Only filter
  ///
  /// In en, this message translates to:
  /// **'Link Only'**
  String get linkOnly;

  /// Message shown when the preview is loading
  ///
  /// In en, this message translates to:
  /// **'Loading link preview...'**
  String get loadingLinkPreview;

  /// Description for the Max History Items setting
  ///
  /// In en, this message translates to:
  /// **'Sets the maximum number of items in the clipboard.'**
  String get maxHistoryItemsDescription;

  /// Message shown when there are no apps ignored during clipboard tracking
  ///
  /// In en, this message translates to:
  /// **'No apps are currently ignored.'**
  String get noAppsAreCurrentlyIgnored;

  /// Message shown when there are no clipboard items
  ///
  /// In en, this message translates to:
  /// **'No clipboard history'**
  String get noClipboardHistory;

  /// Message shown when there are no items for a specific label
  ///
  /// In en, this message translates to:
  /// **'No {category} items'**
  String noItemsForCategory(String category);

  /// Message shown when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// Message shown when no settings are available
  ///
  /// In en, this message translates to:
  /// **'No settings available'**
  String get noSettingsAvailable;

  /// None
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Label for a notification
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Label for the Notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Duration option: 1 hour
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// Button text to open a link
  ///
  /// In en, this message translates to:
  /// **'Open link'**
  String get openLink;

  /// Tray menu item to pause clipboard tracking (enable incognito mode)
  ///
  /// In en, this message translates to:
  /// **'Pause Tracking'**
  String get pauseTracking;

  /// Button text to pin an item
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// Label for the Pinned feature
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// Label for the preview of the content
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Label for the Preview Images setting
  ///
  /// In en, this message translates to:
  /// **'Preview Images'**
  String get previewImages;

  /// Description for the Preview Images setting
  ///
  /// In en, this message translates to:
  /// **'Shows a preview of images in the clipboard.'**
  String get previewImagesDescription;

  /// Label for the Preview Links setting
  ///
  /// In en, this message translates to:
  /// **'Preview Links'**
  String get previewLinks;

  /// Description for the Preview Links setting
  ///
  /// In en, this message translates to:
  /// **'Shows a preview of links in the clipboard.'**
  String get previewLinksDescription;

  /// Label for private session duration options
  ///
  /// In en, this message translates to:
  /// **'Private Session Duration'**
  String get privateSessionDuration;

  /// Name of the pro plan
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// Tray menu item to exit the application
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// Label for the Recent items
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// Button text to resume clipboard capture
  ///
  /// In en, this message translates to:
  /// **'Resume clipboard capture'**
  String get resumeClipboardCapture;

  /// Tray menu item to resume clipboard tracking (disable incognito mode)
  ///
  /// In en, this message translates to:
  /// **'Resume Tracking'**
  String get resumeTracking;

  /// Label for resuming tracking an app
  ///
  /// In en, this message translates to:
  /// **'Resume tracking {appName}'**
  String resumeTrackingApp(String appName);

  /// No description provided for @resumeTrackingAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Resume clipboard tracking for {appName}?'**
  String resumeTrackingAppConfirmation(Object appName);

  /// Label for the Retention Days setting
  ///
  /// In en, this message translates to:
  /// **'Retention Days'**
  String get retentionDays;

  /// Description for the Retention Days setting
  ///
  /// In en, this message translates to:
  /// **'Sets how long items are kept in the clipboard.'**
  String get retentionDaysDescription;

  /// Button text to retry an operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Hint shown in the Search Bar
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// Title for the Settings Page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button text to share content
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Tray menu item to toggle window visibility
  ///
  /// In en, this message translates to:
  /// **'Show/Hide Window'**
  String get showHideWindow;

  /// Label for the Show in Menu Bar setting
  ///
  /// In en, this message translates to:
  /// **'Show in Menu Bar'**
  String get showInMenuBar;

  /// Label for the Show Source App setting
  ///
  /// In en, this message translates to:
  /// **'Show Source App'**
  String get showSourceApp;

  /// Description for the Show Source App setting
  ///
  /// In en, this message translates to:
  /// **'Shows the app that copied the content to the clipboard in the item details.'**
  String get showSourceAppDescription;

  /// Tray menu item to show the window
  ///
  /// In en, this message translates to:
  /// **'Show Window'**
  String get showWindow;

  /// Button text to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Button text to sign in with a specific provider
  ///
  /// In en, this message translates to:
  /// **'Sign in with {provider}'**
  String signInWith(String provider);

  /// Button text to sign out
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Message shown when the user signs in successfully
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully!'**
  String get signedInSuccessfully;

  /// Message shown when signing in
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// Label for the size of the content
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Label for the Snippets feature
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get snippets;

  /// Label for the source of the content
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// Button text to start a private/incognito session
  ///
  /// In en, this message translates to:
  /// **'Start Private Session'**
  String get startPrivateSession;

  /// Button text to stop clipboard capture
  ///
  /// In en, this message translates to:
  /// **'Stop clipboard capture'**
  String get stopClipboardCapture;

  /// Label for stopping tracking an app
  ///
  /// In en, this message translates to:
  /// **'Stop tracking {appName}'**
  String stopTrackingApp(String appName);

  /// Confirmation text shown when stop tracking an app
  ///
  /// In en, this message translates to:
  /// **'LucidClip will no longer save clipboard items copied from {appName}.'**
  String stopTrackingAppConfirmation(String appName);

  /// Label for the Storage settings
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Message shown when the user successfully signs in
  ///
  /// In en, this message translates to:
  /// **'Successfully signed in!'**
  String get successfullySignedIn;

  /// Message shown when the user successfully signs out
  ///
  /// In en, this message translates to:
  /// **'Successfully signed out!'**
  String get successfullySignedOut;

  /// Button text to sync content
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// Label for the Sync Interval setting
  ///
  /// In en, this message translates to:
  /// **'Sync Interval'**
  String get syncInterval;

  /// Description for the Sync Interval setting
  ///
  /// In en, this message translates to:
  /// **'Sets how often the clipboard is synced with the server.'**
  String get syncIntervalDescription;

  /// Name of the system theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Label for the tags feature
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Label for the Text Only filter
  ///
  /// In en, this message translates to:
  /// **'Text Only'**
  String get textOnly;

  /// Label for the Theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Message shown when the user updates their tracking preferences
  ///
  /// In en, this message translates to:
  /// **'Tracking preferences updated!'**
  String get trackingPreferencesUpdated;

  /// Message shown when tracking is resumed for an app
  ///
  /// In en, this message translates to:
  /// **'Tracking resumed for {appName}'**
  String trackingResumedForApp(String appName);

  /// Description shown when tracking is resumed for an app
  ///
  /// In en, this message translates to:
  /// **'Clipboard items from {appName} will now appear in your history.'**
  String trackingResumedForAppDescription(String appName);

  /// Button text to unpin an item
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// Duration option: until manually disabled
  ///
  /// In en, this message translates to:
  /// **'Until Disabled'**
  String get untilDisabled;

  /// Label for the app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Message shown when the clipboard is empty
  ///
  /// In en, this message translates to:
  /// **'Your clipboard items will appear here.'**
  String get yourClipboardItemsWillAppearHere;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

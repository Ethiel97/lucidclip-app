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

  /// Label for the Account section
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Tray menu item to check for app updates
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// Label for account information
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

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

  /// Button text to paste content
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Button text to paste content to another app
  ///
  /// In en, this message translates to:
  /// **'Paste to'**
  String get pasteTo;

  /// Label showing the number of apps with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No apps} =1 {1 app} other {{count} apps}}'**
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

  /// Label for clear clipboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Clear Clipboard'**
  String get clearClipboardShortcut;

  /// Description for clear clipboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Clear all clipboard history'**
  String get clearClipboardShortcutDescription;

  /// Label for the Clipboard feature
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboard;

  /// Button text to paste content to a specific app
  ///
  /// In en, this message translates to:
  /// **'Paste to {appName}'**
  String pasteToApp(String appName);

  /// Message shown when clipboard capture has started
  ///
  /// In en, this message translates to:
  /// **'Clipboard capture started'**
  String get clipboardCaptureStarted;

  /// Message shown when the clipboard is full
  ///
  /// In en, this message translates to:
  /// **'Clipboard full!'**
  String get clipboardFull;

  /// Description shown when the clipboard is full
  ///
  /// In en, this message translates to:
  /// **'Your clipboard has reached its storage limit. Older items will be replaced by new copies.'**
  String get clipboardFullDescription;

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

  /// Title for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Message shown when content is copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Message shown when an item is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'{item} copied to clipboard'**
  String copiedToClipboard(String item);

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

  /// Label showing the number of days with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 day} =1 {1 day} other {{count} days}}'**
  String daysCount(int count);

  /// Button text to delete content
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for the clipboard item's editable content
  ///
  /// In en, this message translates to:
  /// **'Clip content'**
  String get clipContent;

  /// Button text to edit content
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button text to edit a keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Edit Shortcut'**
  String get editShortcut;

  /// Label for email address
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

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

  /// Button text to save changes
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

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

  /// Error message when URL cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Failed to open URL'**
  String get failedToOpenUrl;

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

  /// Label for Free subscription
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeSubscription;

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

  /// Label for the Ignored Source app
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get ignored;

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

  /// Button text to load the subscription management portal
  ///
  /// In en, this message translates to:
  /// **'Load subscription portal'**
  String get loadSubscriptionPortal;

  /// Message shown when the preview is loading
  ///
  /// In en, this message translates to:
  /// **'Loading link preview...'**
  String get loadingLinkPreview;

  /// Button text to manage retention settings
  ///
  /// In en, this message translates to:
  /// **'Manage Retention'**
  String get manageRetention;

  /// Button text to manage subscription
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// Description for the Max History Items setting
  ///
  /// In en, this message translates to:
  /// **'Sets how much history LucidClip can safely retain.'**
  String get maxHistoryItemsDescription;

  /// Label for the maximum history size setting
  ///
  /// In en, this message translates to:
  /// **'Maximum history size'**
  String get maxHistorySize;

  /// Label showing the number of minutes with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 minute} =1 {1 minute} other {{count} minutes}}'**
  String minutesCount(int count);

  /// Label showing the number of months with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 month} =1 {1 month} other {{count} months}}'**
  String monthsCount(int count);

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

  /// Text shown when a value is not available
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// Text shown when a shortcut or value is not configured
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

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

  /// Message shown when clipboard items will overwrite old ones
  ///
  /// In en, this message translates to:
  /// **'Old items will be overwritten. Go pro to keep everything.'**
  String get oldItemsWillBeOverwritten;

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

  /// Placeholder text when recording a keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Press key combination...'**
  String get pressKeyCombination;

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

  /// Label for the Privacy settings
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

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

  /// Label for the Auto-Sync feature
  ///
  /// In en, this message translates to:
  /// **'Auto sync across devices'**
  String get proFeatureAutoSync;

  /// Description for the Auto-Sync feature
  ///
  /// In en, this message translates to:
  /// **'Keeps your clipboard in sync across devices (opt-in).'**
  String get proFeatureAutoSyncDescription;

  /// Label for the Extended Retention Days feature
  ///
  /// In en, this message translates to:
  /// **'Extended Retention Days'**
  String get proFeatureExtendedRetentionDays;

  /// Description for the Extended Retention Days feature
  ///
  /// In en, this message translates to:
  /// **'Keep your history for up to one year.'**
  String get proFeatureExtendedRetentionDaysDescription;

  /// Label for the Ignored Apps feature
  ///
  /// In en, this message translates to:
  /// **'Ignore apps for privacy'**
  String get proFeatureIgnoredApps;

  /// Exclude specific apps from tracking to protect sensitive data.
  ///
  /// In en, this message translates to:
  /// **'Exclude apps from clipboard tracking.'**
  String get proFeatureIgnoredAppsDescription;

  /// Label for the Pin Items feature
  ///
  /// In en, this message translates to:
  /// **'Pin important clips'**
  String get proFeaturePinItems;

  /// Description for the Pin Items feature
  ///
  /// In en, this message translates to:
  /// **'Keep important items forever. Pinned clips are never removed'**
  String get proFeaturePinItemsDescription;

  /// Label for the Unlimited History feature
  ///
  /// In en, this message translates to:
  /// **'Unlimited history'**
  String get proFeatureUnlimitedHistory;

  /// Description for the Unlimited History feature
  ///
  /// In en, this message translates to:
  /// **'Never lose clips. Your history grows with you.'**
  String get proFeatureUnlimitedHistoryDescription;

  /// Label for Pro subscription
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proSubscription;

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

  /// Message shown when redirecting to the secure checkout page
  ///
  /// In en, this message translates to:
  /// **'Redirecting to secure checkout...'**
  String get redirectingToSecureCheckout;

  /// Button text to reset a setting to its default value
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

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

  /// Label indicating that the retention period has expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get retentionExpired;

  /// Label showing when the retention expires
  ///
  /// In en, this message translates to:
  /// **'Auto-Removed in {value} {unit}'**
  String retentionExpiresIn(int value, String unit);

  /// Button text to retry an operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Label for search clipboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Search Clipboard'**
  String get searchClipboardShortcut;

  /// Description for search clipboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Open window and focus search'**
  String get searchClipboardShortcutDescription;

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

  /// Error message when a shortcut conflicts with another
  ///
  /// In en, this message translates to:
  /// **'Shortcut already in use'**
  String get shortcutConflict;

  /// Label for keyboard shortcuts settings section
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcuts;

  /// Description for keyboard shortcuts settings
  ///
  /// In en, this message translates to:
  /// **'Configure global keyboard shortcuts for quick actions'**
  String get shortcutsDescription;

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

  /// Label for show window shortcut
  ///
  /// In en, this message translates to:
  /// **'Show Window'**
  String get showWindowShortcut;

  /// Description for show window shortcut
  ///
  /// In en, this message translates to:
  /// **'Bring the application window to focus'**
  String get showWindowShortcutDescription;

  /// Button text to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Message shown to prompt user to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in to view account information'**
  String get signInToViewAccount;

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

  /// Confirmation dialog shown when signing out
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

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

  /// Label for Snippet input
  ///
  /// In en, this message translates to:
  /// **'Snippet'**
  String get snippet;

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

  /// Message shown when the storage is almost full
  ///
  /// In en, this message translates to:
  /// **'Storage almost full!'**
  String get storageAlmostFull;

  /// Description shown when the storage is almost full
  ///
  /// In en, this message translates to:
  /// **'You\'re using {count}% of your clipboard history.'**
  String storageAlmostFullDescription(int count);

  /// Label for subscription
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// Label for subscription type
  ///
  /// In en, this message translates to:
  /// **'Subscription Type'**
  String get subscriptionType;

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

  /// Label for toggle incognito shortcut
  ///
  /// In en, this message translates to:
  /// **'Toggle Incognito Mode (Shortcut)'**
  String get toggleIncognitoShortcut;

  /// Description for toggle incognito shortcut
  ///
  /// In en, this message translates to:
  /// **'Enable or disable incognito mode'**
  String get toggleIncognitoShortcutDescription;

  /// Label for toggle window shortcut
  ///
  /// In en, this message translates to:
  /// **'Toggle window (Shortcut)'**
  String get toggleWindowShortcut;

  /// Description for toggle window shortcut
  ///
  /// In en, this message translates to:
  /// **'Show or hide LucidClip'**
  String get toggleWindowShortcutDescription;

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

  /// Label for unlimited option
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

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

  /// Footer subtitle for the upgrade paywall sheet
  ///
  /// In en, this message translates to:
  /// **'Local-first by default. No cloud unless you enable it.'**
  String get upgradePaywallSheetFooterSubtitle;

  /// Button text to upgrade to the pro plan
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// Label for the usage section
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// Label for subscription validity date
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// Label for the app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label showing the number of weeks with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 week} =1 {1 week} other {{count} weeks}}'**
  String weeksCount(int count);

  /// Welcome message shown when the user upgrades to Pro
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pro 🎉!'**
  String get welcomeToPro;

  /// Label showing the number of years with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 year} =1 {1 year} other {{count} years}}'**
  String yearsCount(int count);

  /// Message shown to inform the user about increasing storage limit with Pro plan
  ///
  /// In en, this message translates to:
  /// **'You can increase your storage limit with your Pro plan.'**
  String get youCanIncreaseYouStorageLimitWithYourProPlan;

  /// Message shown when the user upgrades to Pro
  ///
  /// In en, this message translates to:
  /// **'You now have access to all Pro features.'**
  String get youNowHavePro;

  /// Message shown when the clipboard history is limited
  ///
  /// In en, this message translates to:
  /// **'Your clipboard history is limited. Go Pro to keep everything.'**
  String get yourClipboardHistoryIsLimited;

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

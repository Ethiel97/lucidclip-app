// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LucidClip';

  @override
  String get characters => 'Characters';

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
  String get delete => 'Delete';

  @override
  String get failedToLoadLinkPreview => 'Failed to load link preview';

  @override
  String get format => 'Format';

  @override
  String get history => 'History';

  @override
  String get information => 'Information';

  @override
  String get itemDetails => 'Item Details';

  @override
  String get link => 'Link';

  @override
  String get loadingLinkPreview => 'Loading link preview...';

  @override
  String noItemsForCategory(String category) {
    return 'No $category items';
  }

  @override
  String get pin => 'Pin';

  @override
  String get pinned => 'Pinned';

  @override
  String get preview => 'Preview';

  @override
  String get recent => 'Recent';

  @override
  String get searchHint => 'Search...';

  @override
  String get settings => 'Settings';

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
  String get tags => 'Tags';

  @override
  String get theme => 'Theme';

  @override
  String get unpin => 'Unpin';
}

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
  String get clipboard => 'Clipboard';

  @override
  String get code => 'Code';

  @override
  String get command => 'Command';

  @override
  String get copy => 'Copy';

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get delete => 'Delete';

  @override
  String get history => 'History';

  @override
  String get link => 'Link';

  @override
  String get pinned => 'Pinned';

  @override
  String get recent => 'Recent';

  @override
  String get settings => 'Settings';

  @override
  String get snippets => 'Snippets';

  @override
  String get storage => 'Storage';

  @override
  String get theme => 'Theme';

  @override
  String get sync => 'Sync';

  @override
  String noItemsForCategory(String category) {
    return 'No $category items';
  }
}

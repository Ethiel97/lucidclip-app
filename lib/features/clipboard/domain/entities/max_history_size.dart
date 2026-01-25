import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:recase/recase.dart';

/// Enum representing the maximum size of clipboard history.
/// Each value corresponds to a specific number of items
/// that can be stored in the clipboard history.
enum MaxHistorySize {
  /// Maximum history size of 30 items.
  size30(30),

  /// Maximum history size of 2000 items.
  size2000(2000),

  /// Maximum history size of 5000 items.
  size5000(5000),

  /// Maximum history size of 10000 items.
  size10000(10000);

  const MaxHistorySize(this.value);

  final int value;

  static MaxHistorySize fromValue(int value) {
    return MaxHistorySize.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MaxHistorySize.size30,
    );
  }

  String resolveLabel(AppLocalizations l10n) =>
      l10n.itemsCount(value).sentenceCase;

  bool get isSize10000 => this == MaxHistorySize.size10000;

  /// default pro size
  bool get isSize5000 => this == MaxHistorySize.size5000;

  bool get isSize2000 => this == MaxHistorySize.size2000;

  /// default free size
  bool get isSize30 => this == MaxHistorySize.size30;
}

import 'package:lucid_clip/l10n/arb/app_localizations.dart';

enum ProFeature {
  pinItems,
  ignoredApps,
  unlimitedHistory,
  autoSync,
  extendedRetentionDays,
}

enum ProFeatureRequestSource {
  pinButton,
  ignoredApps,
  autoSync,
  historyLimitReached,
  extendedRetentionSettings,
  accountPage,
}

extension ProFeatureCopy on ProFeature {
  String title(AppLocalizations l10n) => switch (this) {
    ProFeature.pinItems => l10n.proFeaturePinItems,
    ProFeature.ignoredApps => l10n.proFeatureIgnoredApps,
    ProFeature.unlimitedHistory => l10n.proFeatureUnlimitedHistory,
    ProFeature.autoSync => l10n.proFeatureAutoSync,
    ProFeature.extendedRetentionDays => l10n.proFeatureExtendedRetentionDays,
  };

  String description(AppLocalizations l10n) => switch (this) {
    ProFeature.pinItems => l10n.proFeaturePinItemsDescription,
    ProFeature.ignoredApps => l10n.proFeatureIgnoredAppsDescription,
    ProFeature.unlimitedHistory => l10n.proFeatureUnlimitedHistoryDescription,
    ProFeature.autoSync => l10n.proFeatureAutoSyncDescription,
    ProFeature.extendedRetentionDays =>
      l10n.proFeatureExtendedRetentionDaysDescription,
  };

  String cta(AppLocalizations l10n) => l10n.upgradeToPro;
}

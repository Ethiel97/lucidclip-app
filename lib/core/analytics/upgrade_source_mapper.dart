import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';

/// Map ProFeatureRequestSource to UpgradeSource for analytics tracking
UpgradeSource mapProFeatureSourceToUpgradeSource(
  ProFeatureRequestSource? source,
) {
  return switch (source) {
    ProFeatureRequestSource.historyLimitReached => UpgradeSource.limitHit,
    ProFeatureRequestSource.extendedRetentionSettings ||
    ProFeatureRequestSource.accountPage =>
      UpgradeSource.settings,
    ProFeatureRequestSource.pinButton ||
    ProFeatureRequestSource.ignoredApps ||
    ProFeatureRequestSource.autoSync =>
      UpgradeSource.proGate,
    null => UpgradeSource.proGate,
  };
}

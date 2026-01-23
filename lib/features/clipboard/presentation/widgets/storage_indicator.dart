import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:recase/recase.dart';

// TODO(refactor): Centralize storage policy logic
class StorageIndicator extends StatelessWidget {
  const StorageIndicator({required this.total, required this.used, super.key});

  /// Total storage capacity.
  final int total;

  /// Used storage amount.
  final int used;

  @override
  Widget build(BuildContext context) {
    final guardedTotal = total <= 0 ? 1 : total;

    final ratio = (used / guardedTotal).clamp(0.0, 1.0);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final fill = colorScheme.surfaceContainerHighest;

    final borderColor = ratio >= 0.7
        ? colorScheme.primary.withValues(alpha: 0.35)
        : colorScheme.outline.withValues(alpha: 0.75);

    final isExpanded = context.select((SidebarCubit cubit) => cubit.state);
    final isPro = context.select(
      (EntitlementCubit cubit) => cubit.state.isProActive,
    );

    final progressColors = switch (ratio) {
      < 0.7 => [colorScheme.primary, colorScheme.primary],
      < 0.9 => [colorScheme.primary, colorScheme.secondary],
      _ => [AppColors.dangerSoft, AppColors.danger],
    };

    return GestureDetector(
      onTap: () {
        context.router.navigate(
          SettingsRoute(section: SettingsSection.history.name),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: fill.withValues(alpha: .8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: .6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              spacing: AppSpacing.xxs,
              children: [
                const HugeIcon(icon: HugeIcons.strokeRoundedDatabase),
                if (isExpanded) ...[
                  Expanded(
                    child: Text(
                      l10n.storage.sentenceCase,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onTertiary,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: .9,
                    child: CircularPercentIndicator(
                      radius: 24,
                      lineWidth: 4,
                      percent: ratio,
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.08,
                      ),
                      center: Text(
                        '${(ratio * 100).toStringAsFixed(0)}%',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      linearGradient: LinearGradient(colors: progressColors),
                    ),
                  ),
                ],
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                if (isExpanded)
                  Text(
                    '$used/${l10n.itemsCount(total)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),

                Builder(
                  builder: (context) => switch (isExpanded) {
                    true => Transform.translate(
                      offset: const Offset(-10, 0),
                      child: LinearPercentIndicator(
                        lineHeight: 6,
                        barRadius: const Radius.circular(12),
                        percent: ratio,
                        backgroundColor: colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                        linearGradient: LinearGradient(colors: progressColors),
                      ),
                    ),
                    false => CircularPercentIndicator(
                      radius: 24,
                      lineWidth: 4,
                      percent: ratio,
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.08,
                      ),
                      center: Text(
                        '${(ratio * 100).toStringAsFixed(0)}%',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      linearGradient: LinearGradient(colors: progressColors),
                    ),
                  },
                ),

                const SizedBox(height: 4),
                if (isExpanded)
                  Builder(
                    builder: (context) {
                      final text = switch (ratio) {
                        < 0.65 when !isPro =>
                          l10n.yourClipboardHistoryIsLimited,
                        >= 0.65 when !isPro => l10n.oldItemsWillBeOverwritten,
                        _ => l10n.youCanIncreaseYouStorageLimitWithYourProPlan,
                      };

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.xs,
                        children: [
                          Text(
                            text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (!isPro)
                            TextButton.icon(
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedCrown,
                                size: AppSpacing.md,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.xxxs,
                                  horizontal: AppSpacing.xs,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                foregroundColor: colorScheme.primary,
                                textStyle: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                context.read<UpgradePromptCubit>().request(
                                  ProFeature.unlimitedHistory,
                                  source: ProFeatureRequestSource
                                      .historyLimitReached,
                                );
                              },
                              label: Text(
                                textAlign: TextAlign.start,
                                l10n.upgradeToPro,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

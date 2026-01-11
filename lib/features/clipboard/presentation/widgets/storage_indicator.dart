import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:recase/recase.dart';
import 'package:tinycolor2/tinycolor2.dart';

class StorageIndicator extends StatelessWidget {
  const StorageIndicator({required this.total, required this.used, super.key});

  final int total;
  final int used;

  @override
  Widget build(BuildContext context) {
    final ratio = used / total;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final isExpanded = context.select((SidebarCubit cubit) => cubit.state);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.tertiary
            .toTinyColor()
            .lighten(8)
            .color
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
        ),
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
              if (isExpanded)
                Text(
                  l10n.storage.sentenceCase,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onTertiary,
                  ),
                ),
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

              switch (isExpanded) {
                true => Transform.translate(
                  offset: const Offset(-12, 0),
                  child: LinearPercentIndicator(
                    lineHeight: 6,
                    barRadius: const Radius.circular(12),
                    percent: ratio.clamp(0.0, 1.0),
                    backgroundColor: colorScheme.onPrimary.withValues(
                      alpha: 0.04,
                    ),

                    linearGradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                  ),
                ),
                false => CircularPercentIndicator(
                  radius: 24,
                  lineWidth: 4,
                  percent: ratio.clamp(0.0, 1.0),
                  backgroundColor: colorScheme.onSurface.withValues(
                    alpha: 0.04,
                  ),
                  center: Text(
                    '${(ratio * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  linearGradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                ),
              },
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:tinycolor2/tinycolor2.dart';

class StorageIndicator extends StatelessWidget {
  const StorageIndicator({required this.used, required this.total, super.key});

  final int used;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = used / total;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.tertiary
            .toTinyColor()
            .lighten(8)
            .color
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            l10n.storage.sentenceCase,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onTertiary,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxxs,
            children: [
              Text(
                '$used/${l10n.itemsCount(total)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 6,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            color: colorScheme.onPrimary.withValues(
                              alpha: 0.04,
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: ratio.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.secondary,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

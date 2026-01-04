import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class SettingsThemeSelector extends StatelessWidget {
  const SettingsThemeSelector({
    required this.currentTheme,
    required this.onThemeChanged,
    super.key,
  });

  final String currentTheme;
  final ValueChanged<String> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.theme.sentenceCase,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            l10n.chooseYourAppThemeDescription,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: l10n.light,
                label: Text(l10n.light.sentenceCase),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSun01,
                  size: 18,
                ),
              ),
              ButtonSegment(
                value: l10n.dark,
                label: Text(l10n.dark.sentenceCase),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedMoon01,
                  size: 18,
                ),
              ),
              ButtonSegment(
                value: l10n.system,
                label: Text(l10n.system.sentenceCase),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSetting06,
                  size: 18,
                ),
              ),
            ],
            selected: {currentTheme},
            onSelectionChanged: (Set<String> selected) {
              onThemeChanged(selected.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary.withValues(alpha: 0.4);
                }
                return colorScheme.tertiary;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.onSurface;
                }
                return colorScheme.onSurface;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

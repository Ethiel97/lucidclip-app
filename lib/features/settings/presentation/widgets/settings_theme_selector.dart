import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

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
            'Theme',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            'Choose your preferred color scheme',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'light',
                label: Text('Light'),
                icon: Icon(Icons.light_mode, size: 18),
              ),
              ButtonSegment(
                value: 'dark',
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode, size: 18),
              ),
              ButtonSegment(
                value: 'system',
                label: Text('System'),
                icon: Icon(Icons.settings_suggest, size: 18),
              ),
            ],
            selected: {currentTheme},
            onSelectionChanged: (Set<String> selected) {
              onThemeChanged(selected.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary.withValues(alpha: 0.2);
                }
                return AppColors.surface2;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return AppColors.textSecondary;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

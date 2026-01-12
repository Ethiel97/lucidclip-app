import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class IgnoredAppsTile extends StatelessWidget {
  const IgnoredAppsTile({required this.app, super.key});

  final SourceApp app;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          app.getIconWidget(colorScheme),
          Expanded(
            child: Text(
              app.name,
              style: textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary.withValues(alpha: 0.9),
            ),
            onPressed: () {
              context.read<SettingsCubit>().toggleAppExclusion(app);
            },
            child: Text(l10n.resumeTracking),
          ),
        ],
      ),
    );
  }
}

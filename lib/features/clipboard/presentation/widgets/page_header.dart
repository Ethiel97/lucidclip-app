import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';

// TODO(Ethiel97): Add SearchField here

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appName,
                style: AppTextStyle.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              /* const SizedBox(height: AppSpacing.xxxs),
              Text(
                'All your recent clips, neatly organized.',
                style: textTheme.bodySmall!.copyWith(
                  color: AppColors.textMuted,
                ),
              ),*/
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: const Text('Sync'),
        ),
      ],
    );
  }
}

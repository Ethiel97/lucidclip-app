import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      width: 260,
      color: AppColors.sidebar,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogo(),
          const SizedBox(height: AppSpacing.xlg),
          SidebarItem(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedClipboard),
            label: l10n.clipboard,
            isActive: true,
          ),
          SidebarItem(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedListView,
            ),
            label: l10n.snippets,
          ),
          SidebarItem(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedClock01,
            ),
            label: l10n.history,
          ),
          SidebarItem(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
            ),
            label: l10n.settings,
          ),
          const Spacer(),
          Text(
            l10n.storage.toUpperCase(),
            style: AppTextStyle.functionalXSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const StorageIndicator(
            used: 248,
            total: 1000,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'LucidClip © 2025',
            style: textTheme.bodySmall!.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

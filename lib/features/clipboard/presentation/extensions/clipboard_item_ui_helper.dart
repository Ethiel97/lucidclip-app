import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

extension ClipboardUiHelper on ClipboardItem {
  Widget get icon {
    final (icon, color) = switch (type) {
      ClipboardItemType.text => (
        const HugeIcon(icon: HugeIcons.strokeRoundedNote),
        AppColors.success,
      ),
      ClipboardItemType.image => (
        const HugeIcon(icon: HugeIcons.strokeRoundedImage01),
        AppColors.danger,
      ),
      ClipboardItemType.file => (
        const HugeIcon(icon: HugeIcons.strokeRoundedFolderOpen),
        AppColors.warning,
      ),
      ClipboardItemType.url => (
        const HugeIcon(icon: HugeIcons.strokeRoundedLink01),
        AppColors.primary,
      ),
      _ => (
        const HugeIcon(icon: HugeIcons.strokeRoundedClipboard),
        AppColors.textSecondary,
      ),
    };

    return IconTheme(
      data:  IconThemeData(color: color, size: AppSpacing.md),
      child: icon,
    );
  }
}

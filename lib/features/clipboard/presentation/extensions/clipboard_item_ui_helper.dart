import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

extension ClipboardUiHelper on ClipboardItem {
  Widget get icon {
    final icon = switch (type) {
      ClipboardItemType.text =>
        const HugeIcon(icon: HugeIcons.strokeRoundedNote),
      ClipboardItemType.image =>
        const HugeIcon(icon: HugeIcons.strokeRoundedImage01),
      ClipboardItemType.file =>
        const HugeIcon(icon: HugeIcons.strokeRoundedFolderOpen),
      ClipboardItemType.url =>
        const HugeIcon(icon: HugeIcons.strokeRoundedLink01),
      _ => const HugeIcon(icon: HugeIcons.strokeRoundedClipboard),
    };

    return IconTheme(
      data: const IconThemeData(
        // color: color,
        size: AppSpacing.md,
      ),
      child: icon,
    );
  }
}

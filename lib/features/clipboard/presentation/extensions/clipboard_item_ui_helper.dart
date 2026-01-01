import 'dart:typed_data';

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
      data: IconThemeData(color: color, size: AppSpacing.md),
      child: icon,
    );
  }

  Widget get preview {
    final textPreview = Text(
      content,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
    );

    return switch (type) {
      ClipboardItemType.text ||
      ClipboardItemType.file ||
      ClipboardItemType.url => textPreview,
      ClipboardItemType.image when imageBytes != null => Image.memory(
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
      ),

      _ => textPreview,
    };
  }
}

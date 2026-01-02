import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';

extension ClipboardUiHelper on ClipboardItem {
  Widget get icon {
    final (icon, color) = switch (type) {
      ClipboardItemType.text => (
        const HugeIcon(icon: HugeIcons.strokeRoundedNote),
        AppColors.successSoft,
      ),
      ClipboardItemType.image => (
        const HugeIcon(icon: HugeIcons.strokeRoundedImage01),
        AppColors.dangerSoft,
      ),
      ClipboardItemType.file => (
        const HugeIcon(icon: HugeIcons.strokeRoundedFolderOpen),
        AppColors.warningSoft
      ),
      ClipboardItemType.url => (
        const HugeIcon(icon: HugeIcons.strokeRoundedLink01),
        AppColors.primarySoft,
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

  bool get isImageFile =>
      (filePath?.isNotEmpty ?? true) && File(filePath!).isImage;

  Widget preview({int? maxLines}) {
    final textPreview = Text(
      content,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
    );

    return switch (type) {
      ClipboardItemType.text || ClipboardItemType.url => textPreview,

      //if the file is an image, try to load and display it
      ClipboardItemType.file when isImageFile => Image.file(
        File(filePath!),
        gaplessPlayback: true,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        width: 50,
      ),

      // TODO(Ethiel97): handle documents and other file types previews
      ClipboardItemType.image when imageBytes != null => Image.memory(
        gaplessPlayback: true,
        Uint8List.fromList(imageBytes!),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        width: 50,
      ),

      _ => textPreview,
    };
  }
}

extension ClipboardItemTypeUiHelper on ClipboardItemType {
  String filterTypeLabel(AppLocalizations l10n) => switch (this) {
    FilterType.image => l10n.imageOnly,
    FilterType.file => l10n.fileOnly,
    FilterType.url => l10n.linkOnly,
    _ => l10n.textOnly,
  };
}

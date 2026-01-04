import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';

final Map<String, Uint8List> _imagePreviewCache = {};
final Map<String, Uint8List> _sourceAppIconCache = {};
const _sourceAppDisplaySize = 30;

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
        AppColors.warningSoft,
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

    if (type case ClipboardItemType.text || ClipboardItemType.url) {
      return textPreview;
    } else if (type case ClipboardItemType.file when isImageFile) {
      return Image.file(
        File(filePath!),
        gaplessPlayback: true,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        width: 50,
      );
    } else if (type case ClipboardItemType.image when imageBytes != null) {
      final cachedKey = 'clipboard_image_$id';
      final cachedBytes = _imagePreviewCache.putIfAbsent(
        cachedKey,
        () => Uint8List.fromList(imageBytes!),
      );
      return Image.memory(
        gaplessPlayback: true,
        cachedBytes,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        width: 50,
      );
    } else {
      return textPreview;
    }
  }

  Widget get sourceAppIcon {
    if (sourceApp?.icon != null) {
      final cachedKey = '${sourceApp?.bundleId}';
      final cachedBytes = _sourceAppIconCache.putIfAbsent(
        cachedKey,
        () => Uint8List.fromList(sourceApp!.icon!),
      );

      return Image.memory(
        cacheHeight: _sourceAppDisplaySize,
        cacheWidth: _sourceAppDisplaySize,
        cachedBytes,
        gaplessPlayback: true,
        width: _sourceAppDisplaySize.toDouble(),
        height: _sourceAppDisplaySize.toDouble(),
        fit: BoxFit.cover,
      );
    } else {
      return const HugeIcon(
        icon: HugeIcons.strokeRounded0Square,
        size: 20,
        color: AppColors.textMuted,
      );
    }
  }
}

extension ClipboardItemTypeUiHelper on ClipboardItemType {
  String filterTypeLabel(AppLocalizations l10n) => switch (this) {
    FilterType.image => l10n.imageOnly,
    FilterType.file => l10n.fileOnly,
    FilterType.url => l10n.linkOnly,
    FilterType.unknown => l10n.allTypes,
    _ => l10n.textOnly,
  };
}

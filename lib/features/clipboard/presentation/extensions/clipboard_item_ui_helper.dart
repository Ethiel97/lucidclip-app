import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';

final Map<String, Uint8List> _imagePreviewCache = {};
final Map<String, Uint8List> _sourceAppIconCache = {};
const _sourceAppDisplaySize = 24;

// Cached icon widgets to avoid rebuilding
const _iconText = IconTheme(
  data: IconThemeData(color: AppColors.successSoft, size: AppSpacing.md),
  child: HugeIcon(icon: HugeIcons.strokeRoundedNote),
);

const _iconImage = IconTheme(
  data: IconThemeData(color: AppColors.dangerSoft, size: AppSpacing.md),
  child: HugeIcon(icon: HugeIcons.strokeRoundedImage01),
);

const _iconFile = IconTheme(
  data: IconThemeData(color: AppColors.warningSoft, size: AppSpacing.md),
  child: HugeIcon(icon: HugeIcons.strokeRoundedFolderOpen),
);

const _iconUrl = IconTheme(
  data: IconThemeData(color: AppColors.primarySoft, size: AppSpacing.md),
  child: HugeIcon(icon: HugeIcons.strokeRoundedLink01),
);

const _iconUnknown = IconTheme(
  data: IconThemeData(color: AppColors.textSecondary, size: AppSpacing.md),
  child: HugeIcon(icon: HugeIcons.strokeRoundedClipboard),
);

extension ClipboardUiHelper on ClipboardItem {
  Widget get icon {
    return switch (type) {
      ClipboardItemType.text => _iconText,
      ClipboardItemType.image => _iconImage,
      ClipboardItemType.file => _iconFile,
      ClipboardItemType.url => _iconUrl,
      _ => _iconUnknown,
    };
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
      return CachedClipboardImage.file(filePath: filePath);
    } else if (type case ClipboardItemType.image when imageBytes != null) {
      final cachedKey = 'clipboard_image_$id';
      final cachedBytes = _imagePreviewCache.putIfAbsent(
        cachedKey,
        () => Uint8List.fromList(imageBytes!),
      );
      return CachedClipboardImage.memory(bytes: cachedBytes);
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

      return CachedClipboardImage.memory(
        bytes: cachedBytes,
        width: _sourceAppDisplaySize.toDouble(),
        height: _sourceAppDisplaySize.toDouble(),
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

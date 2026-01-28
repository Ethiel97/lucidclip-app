import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';

final _imagePreviewCache = LruBytesCache(200);

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
  Widget get linkPreviewWidget {
    if (type case ClipboardItemType.url) {
      return LinkPreviewWidget(url: content);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget get icon {
    return switch (type) {
      ClipboardItemType.text => _iconText,
      ClipboardItemType.image => _iconImage,
      ClipboardItemType.file => _iconFile,
      ClipboardItemType.url => _iconUrl,
      _ => _iconUnknown,
    };
  }

  bool get isImageFile {
    final path = filePath;
    if (path == null || path.isEmpty) return false;
    return File(path).isImage;
  }

  Widget preview({
    required ColorScheme colorScheme,
    int? maxLines,
    bool showLinkPreview = true,
    double? imageWidth = 50,
    double? imageHeight = 50,
  }) {
    final textPreview = Text(
      content,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
    );

    if (type case ClipboardItemType.text) {
      return textPreview;
    }

    if (type case ClipboardItemType.url) {
      return Column(
        spacing: AppSpacing.xs,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [textPreview, if (showLinkPreview) linkPreviewWidget],
      );
    } else if (type case ClipboardItemType.file when isImageFile) {
      return CachedClipboardImage.file(
        filePath: filePath,
        width: imageWidth,
        height: imageHeight,
      );
    } else if (type case ClipboardItemType.image when imageBytes != null) {
      final cachedKey = 'clipboard_image_$id';
      final cachedBytes = _imagePreviewCache.put(
        cachedKey,
        Uint8List.fromList(imageBytes!),
      );
      return CachedClipboardImage.memory(
        bytes: cachedBytes,
        width: imageWidth,
        height: imageHeight,
      );
    } else {
      return textPreview;
    }
  }

  Widget resolveSourceAppIcon(ColorScheme colorScheme) =>
      sourceApp?.getIconWidget(colorScheme) ??
      CircleAvatar(
        radius: 12,
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          sourceApp?.name.isNotEmpty ?? false
              ? sourceApp!.name.substring(0, 1).toUpperCase()
              : '?',
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}

extension ClipboardItemTypeUiHelper on ClipboardItemType {
  String resolveFilterTypeLabel(AppLocalizations l10n) => switch (this) {
    FilterType.image => l10n.imageOnly,
    FilterType.file => l10n.fileOnly,
    FilterType.url => l10n.linkOnly,
    FilterType.unknown => l10n.allTypes,
    _ => l10n.textOnly,
  };
}

extension I18nTextResolver on I18nText {
  String resolve(AppLocalizations l10n) => switch (key) {
    'retentionExpiresIn' => l10n.retentionExpiresIn(
      args['value']! as int,
      args['unit']! as String,
    ),
    'retentionExpired' => l10n.retentionExpired,
    _ => key,
  };
}

extension RetentionWarningUi on RetentionWarning {
  String? resolveLabel(AppLocalizations l10n) => text?.resolve(l10n);

  Widget resolveBadge({
    required AppLocalizations l10n,
    required ColorScheme colorScheme,
  }) {
    final label = resolveLabel(l10n);
    if (label == null || level.isNone) return const SizedBox.shrink();

    final color = switch (level) {
      RetentionWarningLevel.warning => colorScheme.errorContainer,
      RetentionWarningLevel.danger => colorScheme.error,
      _ => colorScheme.onError,
    };

    return ClipboardBadge(label: label, color: color);
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

final Map<String, Uint8List> _sourceAppIconCache = {};
const _sourceAppDisplaySize = 18;
const sourceAppProviderTimeoutMs = 2500;

extension SourceAppHelper on SourceApp {
  Widget getIconWidget(ColorScheme colorScheme) {
    if (icon != null) {
      final cachedKey = bundleId;
      final cachedBytes = _sourceAppIconCache.putIfAbsent(
        cachedKey,
        () => Uint8List.fromList(icon!),
      );

      return Transform.scale(
        scale: 1.2,
        child: CachedClipboardImage.memory(
          bytes: cachedBytes,
          width: _sourceAppDisplaySize.toDouble(),
          height: _sourceAppDisplaySize.toDouble(),
        ),
      );
    } else {
      return HugeIcon(
        icon: HugeIcons.strokeRounded0Square,
        size: 20,
        color: colorScheme.onSurfaceVariant,
      );
    }
  }
}

//ignore: one_member_abstracts
abstract class SourceAppProvider {
  Future<SourceApp?> getFrontmostApp();
}

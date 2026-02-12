import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class CopyableContent extends StatelessWidget {
  const CopyableContent({
    required this.title,
    required this.value,
    required this.child,
    this.copyable = true,
    super.key,
  });

  final String title;
  final String value;
  final bool copyable;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xxs,
      children: [
        if (copyable)
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.copiedToClipboard(title)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedCopy01,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),

        Flexible(child: child),
      ],
    );
  }
}

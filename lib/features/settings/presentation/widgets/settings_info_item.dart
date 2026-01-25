import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:tinycolor2/tinycolor2.dart';

class SettingsInfoItem extends StatelessWidget {
  const SettingsInfoItem({
    required this.title,
    required this.value,
    super.key,
    this.leading,
    this.copyable = false,
  });

  final String title;
  final String value;
  final Widget? leading;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (copyable)
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title copied to clipboard'),
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
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.toTinyColor().darken(5).color,
            ),
          ),
        ],
      ),
    );
  }
}

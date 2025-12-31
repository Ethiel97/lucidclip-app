import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:recase/recase.dart';

class ClipboardItemTagChip extends StatelessWidget {
  const ClipboardItemTagChip({required this.label, this.color, super.key});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tagColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tagColor.withValues(alpha: 0.13),
        border: Border.all(color: tagColor.withValues(alpha: 0.33)),
      ),
      child: Text(
        label.sentenceCase,
        style: textTheme.labelSmall?.copyWith(color: tagColor, fontSize: 12),
      ),
    );
  }
}

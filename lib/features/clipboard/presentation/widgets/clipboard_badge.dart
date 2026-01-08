import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:recase/recase.dart';

class ClipboardBadge extends StatelessWidget {
  const ClipboardBadge({required this.label, this.color, super.key});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
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
        style: TextStyle(
          color: tagColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:recase/recase.dart';

class ClipboardBadge extends StatelessWidget {
  const ClipboardBadge({
    required this.label,
    this.color,
    this.padding,
    super.key,
  });

  final Color? color;
  final String label;
  final EdgeInsets? padding;

  EdgeInsets get defaultPadding => const EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.xxxs,
  );

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tagColor.withValues(alpha: 0.13),
        border: Border.all(color: tagColor.withValues(alpha: 0.33)),
      ),
      child: Text(
        label.sentenceCase,
        style: TextStyle(
          color: tagColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

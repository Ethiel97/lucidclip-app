import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyle.functionalSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Divider(color: colorScheme.outline.withValues(alpha: .8)),
          ),
        ],
      ),
    );
  }
}

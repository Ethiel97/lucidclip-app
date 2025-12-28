import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyle.functionalSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Divider(
              color: AppColors.textMuted.withValues(alpha: 0.2),
              thickness: 1,
            ),
          ),
        ],
      );
}

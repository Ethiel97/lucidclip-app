import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.icon,
    required this.label,
    super.key,
    this.isActive = false,
  });

  final Widget icon;
  final String label;
  final bool isActive;

  Color get _backgroundColor =>
      isActive ? AppColors.primary.withValues(alpha: 0.13) : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxs),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.13) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(
                  color: color,
                  size: AppSpacing.lg,
                ),
                child: icon,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

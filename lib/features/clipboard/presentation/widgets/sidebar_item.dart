import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    required this.icon,
    required this.label,
    super.key,
    this.isActive = false,
  });

  final Widget icon;
  final String label;
  final bool isActive;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovering = false;

  Color get backgroundColor {
    if (widget.isActive) {
      return AppColors.primary.withValues(alpha: 0.13);
    } else if (_isHovering) {
      return AppColors.textSecondary.withValues(alpha: 0.05);
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? AppColors.primary : AppColors.textSecondary;

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxs),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(color: color, size: AppSpacing.lg),
                  child: widget.icon,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight:
                        widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

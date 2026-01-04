import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final contentColor = widget.isSelected
        ? colorScheme.primary
        : (_isHovering ? colorScheme.onSurface : colorScheme.onTertiary);

    final backgroundColor = widget.isSelected
        ? colorScheme.primary.withValues(alpha: 0.1)
        : (_isHovering ? colorScheme.tertiary : Colors.transparent);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(color: contentColor, size: 20),
                child: widget.icon,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: contentColor,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (widget.isSelected)
                Container(
                  width: AppSpacing.xxs,
                  height: AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

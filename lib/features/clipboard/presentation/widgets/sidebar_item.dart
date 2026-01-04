import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/cubit/cubit.dart';

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

    final isExpanded = context.select((SidebarCubit cubit) => cubit.state);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: contentColor),
                child: widget.icon,
              ),
              if (isExpanded) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isExpanded ? 1.0 : 0.0,
                      child: isExpanded
                          ? Container(
                              padding: const EdgeInsets.only(
                                left: AppSpacing.sm,
                              ),
                              child: Text(
                                widget.label,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: contentColor,
                                  fontWeight: widget.isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
                if (widget.isSelected) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: AppSpacing.xxs,
                    height: AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

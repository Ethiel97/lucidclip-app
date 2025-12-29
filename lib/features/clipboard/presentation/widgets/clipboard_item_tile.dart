import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:recase/recase.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile>
     {


  bool isHovering = false;

  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(alpha: 0.5)
      : AppColors.surface;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    // TODO(Ethiel97): USE clipboard selection state to determine if item is selected

    return GestureDetector(
      onTap: () {
        // TODO(Ethiel97): Handle item tap
      },
      onSecondaryTap: () {
        // TODO(Ethiel97): Show context menu
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovering = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              widget.item.icon,
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    /*const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      item.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),*/
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ItemTag(
                label: widget.item.type.label.sentenceCase,
                color: primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 100,
                child: Text(
                  widget.item.timeAgo,
                  style: textTheme.displaySmall?.copyWith(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemTag extends StatelessWidget {
  const _ItemTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.13),
        border: Border.all(color: color.withValues(alpha: 0.33)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(color: color, fontSize: 12),
      ),
    );
  }
}

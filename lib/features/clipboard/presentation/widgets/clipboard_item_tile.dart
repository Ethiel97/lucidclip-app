import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile> {
  bool isHovering = false;

  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(alpha: 0.5)
      : AppColors.surface;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        context.read<ClipboardDetailCubit>().setClipboardItem(widget.item);
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
              ClipboardItemTagChip(label: widget.item.type.label),
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

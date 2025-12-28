import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:recase/recase.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({
    required this.item,
    super.key,
  });

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile> {
  bool isHovering = false;

  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(
          alpha: 0.5,
        )
      : AppColors.surface;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        // TODO(Ethiel97): Handle item tap
      },
      onSecondaryTap: () {
        // TODO(Ethiel97): Show context menu
      },
      child: MouseRegion(
        onHover: (_) {
          setState(() {
            isHovering = true;
          });
        },
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
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
              _ItemLeadingIcon(icon: widget.item.icon),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
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
                label: widget.item.type.name.sentenceCase,
                color: primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.item.timeAgo,
                style: AppTextStyle.bodyXSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemLeadingIcon extends StatelessWidget {
  const _ItemLeadingIcon({required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.xlg,
      width: AppSpacing.xlg,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: icon,
    );
  }
}

class _ItemTag extends StatelessWidget {
  const _ItemTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.13),
      ),
      child: Text(
        label,
        style: AppTextStyle.labelSmall.copyWith(
          color: color,
        ),
      ),
    );
  }
}

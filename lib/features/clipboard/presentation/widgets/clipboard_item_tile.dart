import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile> {
  LinkPreviewController? _linkPreviewController;
  bool isHovering = false;

  @override
  void dispose() {
    _linkPreviewController?.dispose();
    super.dispose();
  }

  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(alpha: 0.4)
      : AppColors.surface;

  bool get shouldShowLinkPreview => widget.item.type.isUrl && isHovering;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!isHovering) {
          setState(() => isHovering = true);
        }
      },
      onExit: (_) {
        if (isHovering) {
          setState(() => isHovering = false);
        }
      },
      child: GestureDetector(
        onTap: () {
          context.read<ClipboardDetailCubit>().setClipboardItem(widget.item);
        },
        child: ClipboardContextMenu(
          clipboardItem: widget.item,
          child: Container(
            height: 60,
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
                  child: shouldShowLinkPreview && widget.item.type.isUrl
                      ? _LinkPreviewWidget(
                          item: widget.item,
                          controller: _linkPreviewController ??= LinkPreviewController(),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: widget.item.preview(maxLines: 1),
                        ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ClipboardItemTagChip(label: widget.item.type.label),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.item.timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
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

class _LinkPreviewWidget extends StatelessWidget {
  const _LinkPreviewWidget({required this.item, required this.controller});

  final ClipboardItem item;
  final LinkPreviewController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final isLinkPreviewEnabled = context.select(
      (SettingsCubit cubit) => cubit.state.previewLinks,
    );

    return PortalTarget(
      anchor: const Aligned(
        follower: Alignment.topLeft,
        target: Alignment.bottomLeft,
      ),
      visible: isLinkPreviewEnabled,
      portalFollower: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: LinkPreview.compact(
          controller: controller,
          url: item.content,
          errorBuilder: (context, error) => Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.surface,
            child: Text(
              l10n.failedToLoadLinkPreview,
              style: textTheme.bodySmall?.copyWith(),
            ),
          ),
          loadingBuilder: (context) => Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.surface,
            child: Column(
              spacing: AppSpacing.sm,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.loadingLinkPreview,
                  style: textTheme.bodySmall?.copyWith(),
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          ),
        ),
      ),
      child: item.preview(maxLines: 1),
    );
  }
}

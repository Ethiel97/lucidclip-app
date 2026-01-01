import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile> {
  late LinkPreviewController _linkPreviewController;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    _linkPreviewController = LinkPreviewController();
  }

  @override
  void dispose() {
    _linkPreviewController.dispose();
    super.dispose();
  }


  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(alpha: 0.5)
      : AppColors.surface;

  bool get shouldShowLinkPreview => widget.item.type.isUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.item.icon,
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PortalTarget(
                  anchor: const Aligned(
                    follower: Alignment.topLeft,
                    target: Alignment.bottomLeft,
                  ),
                  visible: isHovering && shouldShowLinkPreview,
                  portalFollower: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: LinkPreview.compact(
                      controller: _linkPreviewController,
                      url: widget.item.content,
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
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: widget.item.preview,
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

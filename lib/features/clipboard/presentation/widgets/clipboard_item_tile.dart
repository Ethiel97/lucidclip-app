import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:metalink_flutter/metalink_flutter.dart';
import 'package:recase/recase.dart';

typedef ClipboardContextMenuItem = ({String label, Object icon});

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

  void _onHoverEnter() {
    if (isHovering) return;
    setState(() {
      isHovering = true;
    });
  }

  void _onHoverExit() {
    setState(() {
      isHovering = false;
    });
  }

  Color get _backgroundColor => isHovering
      ? AppColors.surface2.withValues(alpha: 0.4)
      : AppColors.surface;

  bool get shouldShowLinkPreview => widget.item.type.isUrl && isHovering;

  List<Widget> getContextMenuItems(AppLocalizations l10n) {
    final menu = <ClipboardContextMenuItem>[
      (
        label: widget.item.isPinned ? l10n.unpin : l10n.pin.sentenceCase,
        icon: widget.item.isPinned
            ? HugeIcons.strokeRoundedPinOff
            : HugeIcons.strokeRoundedPin,
      ),
      (label: l10n.delete.sentenceCase, icon: HugeIcons.strokeRoundedDelete01),
      (label: l10n.edit.sentenceCase, icon: HugeIcons.strokeRoundedEdit01),
      (label: l10n.copy.sentenceCase, icon: HugeIcons.strokeRoundedCopy01),
    ];
    return menu
        .map(
          (item) => ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Text(item.label),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: HugeIcon(icon: item.icon as List<List>),
            ),
            onTap: () {
              switch (item.label) {
                case final l when l == l10n.pin.sentenceCase:
                  context.read<ClipboardDetailCubit>().togglePinClipboardItem(
                    widget.item,
                  );
                case final l when l == l10n.delete.sentenceCase:
                  context.read<ClipboardDetailCubit>().deleteClipboardItem(
                    widget.item,
                  );
                case final l when l == l10n.edit.sentenceCase:
                  // TODO(Ethiel97): Handle edit action
                  break;
                case final l when l == l10n.copy.sentenceCase:
                  getIt<BaseClipboardManager>().setClipboardContent(
                    widget.item.toInfrastructure(),
                  );

                // Add other cases as needed
              }

              Navigator.pop(context);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () {
        context.read<ClipboardDetailCubit>().setClipboardItem(widget.item);
      },
      child: ContextMenuArea(
        builder: (context) => getContextMenuItems(l10n),
        verticalPadding: AppSpacing.sm,
        child: MouseRegion(
          onEnter: (_) => _onHoverEnter(),
          onExit: (_) => _onHoverExit(),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            key: ValueKey(widget.item.id),
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
                    visible: shouldShowLinkPreview,
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:metalink_flutter/metalink_flutter.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ClipboardItemTile extends StatefulWidget {
  const ClipboardItemTile({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<ClipboardItemTile> createState() => _ClipboardItemTileState();
}

class _ClipboardItemTileState extends State<ClipboardItemTile> {
  bool isHovering = false;
  LinkPreviewController? _linkPreviewController;

  @override
  void dispose() {
    _linkPreviewController?.dispose();
    super.dispose();
  }

  Color getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return isHovering
        ? colorScheme.tertiary
              .toTinyColor()
              .darken(5)
              .color
              .withValues(alpha: 0.5)
        : colorScheme.surface.toTinyColor().darken(2).color;
  }

  bool get shouldShowLinkPreview => widget.item.type.isUrl && isHovering;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            // height: 52,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: getBackgroundColor(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.outline, width: .6),
            ),
            child: Row(
              children: [
                widget.item.icon,
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RepaintBoundary(
                      child: widget.item.preview(
                        maxLines: 1,
                        colorScheme: colorScheme,
                        showLinkPreview: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                if (isHovering) RetentionWarningBadge(item: widget.item),

                const SizedBox(width: AppSpacing.sm),
                widget.item.resolveTypeBadge(l10n: context.l10n),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 110,
                  child: Text(
                    widget.item.timeAgo,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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

class LinkPreviewWidget extends StatelessWidget {
  const LinkPreviewWidget({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final isLinkPreviewEnabled = context.select(
      (SettingsCubit cubit) => cubit.state.previewLinks,
    );

    return switch (isLinkPreviewEnabled) {
      false => const SizedBox.shrink(),
      true => SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: LinkPreview.card(
          url: url,
          errorBuilder: (context, error) => Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: colorScheme.surface,
            child: Text(
              l10n.failedToLoadLinkPreview,
              style: textTheme.bodySmall?.copyWith(),
            ),
          ),
          loadingBuilder: (context) => Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: colorScheme.surface,
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
    };
  }
}

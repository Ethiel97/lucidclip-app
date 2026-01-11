import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/theme/app_colors.dart';
import 'package:lucid_clip/core/theme/app_spacing.dart';
import 'package:lucid_clip/core/theme/app_text_styles.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ClipboardItemDetailsView extends StatefulWidget {
  const ClipboardItemDetailsView({
    required this.clipboardItem,
    super.key,
    this.onClose,
    this.onCopyPressed,
    this.onDelete,
    this.onTogglePin,
  });

  final ClipboardItem clipboardItem;
  final VoidCallback? onClose;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onTogglePin;

  @override
  State<ClipboardItemDetailsView> createState() =>
      _ClipboardItemDetailsViewState();
}

class _ClipboardItemDetailsViewState extends State<ClipboardItemDetailsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant ClipboardItemDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.clipboardItem.id != widget.clipboardItem.id) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Container(
      width: AppConstants.clipboardItemDetailsViewWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg),
          bottomLeft: Radius.circular(AppSpacing.lg),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.itemDetails.sentenceCase,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    widget.onClose?.call();
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                trackVisibility: false,
                thumbVisibility: false,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: RepaintBoundary(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(l10n.preview.toUpperCase()),
                        const SizedBox(height: AppSpacing.xs),
                        _PreviewCard(
                          previewWidget: widget.clipboardItem.preview(
                            maxLines: 500,
                            colorScheme: colorScheme,
                          ),
                          preview: widget.clipboardItem.content,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        _SectionLabel(l10n.information.toUpperCase()),
                        const SizedBox(height: AppSpacing.xs),
                        _InfoCard(clipboardItem: widget.clipboardItem),
                        if (widget.clipboardItem.type.label.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _SectionLabel(l10n.tags.toUpperCase()),
                          const SizedBox(height: AppSpacing.xs),
                          _TagsWrap(tags: [widget.clipboardItem.type.label]),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            _ActionsRow(
              isPinned: widget.clipboardItem.isPinned,
              onCopyPressed: widget.onCopyPressed,
              onTogglePin: widget.onTogglePin,
              onDelete: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyle.functionalSmall.copyWith(color: AppColors.textMuted),
    );
  }
}

// TODO(Ethiel97): Improve preview card to handle different content types better
class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.preview, this.previewWidget});

  final String preview;
  final Widget? previewWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: RepaintBoundary(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child:
              previewWidget ??
              Text(
                preview,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.clipboardItem});

  final ClipboardItem clipboardItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shouldShowSourceApp = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.showSourceApp,
    );

    final excludedApps = context.select<SettingsCubit, List<SourceApp>>(
      (cubit) => cubit.state.excludedApps,
    );

    final isSourceAppValid = clipboardItem.sourceApp?.isValid ?? false;
    final isSourceAppExcluded = clipboardItem.getIsSourceAppExcluded(
      excludedApps,
    );

    return Column(
      spacing: AppSpacing.sm,
      children: [
        if (shouldShowSourceApp && isSourceAppValid)
          _InfoRow(
            label: l10n.source.sentenceCase,
            actionWidget: SourceAppPrivacyControl(clipboardItem: clipboardItem),
            valueWidget: Row(
              spacing: AppSpacing.sm,
              children: [
                Row(
                  spacing: AppSpacing.xxs,
                  children: [
                    clipboardItem.sourceAppIcon,
                    Text(
                      clipboardItem.sourceApp!.name,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),

                if (isSourceAppExcluded) const ExcludedSourceAppBadge(),
              ],
            ),
            value: clipboardItem.sourceApp!.name,
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedComputer),
          ),
        _InfoRow(
          label: l10n.copied.sentenceCase,
          value: clipboardItem.timeAgo,
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedClock01),
        ),
        _InfoRow(
          label: l10n.size.sentenceCase,
          value: clipboardItem.userFacingSize,
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedDatabase),
        ),
        _InfoRow(
          label: l10n.characters.sentenceCase,
          value: clipboardItem.content.length.toString(),
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedText),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.actionWidget,
    this.valueWidget,
  });

  final String label;
  final String value;
  final Widget icon;
  final Widget? valueWidget;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Row(
            children: [
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: AppSpacing.sm,
                    color: colorScheme.onTertiary,
                  ),
                  child: icon,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: .7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    valueWidget ??
                        Text(
                          value,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),

          ?actionWidget,
        ],
      ),
    );
  }
}

class _TagsWrap extends StatelessWidget {
  const _TagsWrap({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxxs,
      children: tags.map((t) => ClipboardBadge(label: t)).toList(),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.isPinned,
    this.onCopyPressed,
    this.onTogglePin,
    this.onDelete,
  });

  final bool isPinned;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onTogglePin;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Primary action
        Expanded(
          child: FilledButton.icon(
            onPressed: onCopyPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.outline),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedCopy01, size: 16),
            label: Text(l10n.copy.sentenceCase),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Pin
        OutlinedButton.icon(
          onPressed: onTogglePin,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.outline),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          icon: HugeIcon(
            icon: isPinned
                ? HugeIcons.strokeRoundedPinOff
                : HugeIcons.strokeRoundedPin,
            size: 16,
          ),
          label: Text(
            isPinned ? l10n.unpin.sentenceCase : l10n.pin.sentenceCase,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        // Favorite
        OutlinedButton.icon(
          onPressed: onDelete,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.errorContainer, width: .2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedDelete01,
            size: 16,
            color: colorScheme.error,
          ),
          label: Text(
            l10n.delete.sentenceCase,
            style: textTheme.labelSmall?.copyWith(color: colorScheme.error),
          ),
        ),
      ],
    );
  }
}

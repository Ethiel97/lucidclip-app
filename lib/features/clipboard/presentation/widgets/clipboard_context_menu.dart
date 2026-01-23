import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

enum ClipboardMenuAction {
  appendToClipboard,
  openLink,
  copyPath,
  edit,
  togglePin,
  deleteItem,
  clearHistory,
}

typedef ClipboardContextMenuItem = ({
  ClipboardMenuAction action,
  String label,
  Object icon,
});

class ClipboardContextMenu extends StatelessWidget {
  const ClipboardContextMenu({
    required this.child,
    required this.clipboardItem,
    super.key,
  });

  final Widget child;
  final ClipboardItem clipboardItem;

  // --- Sections -------------------------------------------------------------

  List<ClipboardContextMenuItem> _primaryActions(
    AppLocalizations l10n,
    ClipboardItem item,
  ) => [
    (
      action: ClipboardMenuAction.appendToClipboard,
      label: l10n.appendToClipboard.sentenceCase,
      icon: HugeIcons.strokeRoundedCopy01,
    ),
    if (item.type.isUrl)
      (
        action: ClipboardMenuAction.openLink,
        label: l10n.openLink.sentenceCase,
        icon: HugeIcons.strokeRoundedBrowser,
      ),
    if (item.type.isFile)
      (
        action: ClipboardMenuAction.copyPath,
        label: l10n.copyPath.sentenceCase,
        icon: HugeIcons.strokeRoundedFolderMoveTo,
      ),
    if (!item.type.isImage && !item.type.isFile)
      (
        action: ClipboardMenuAction.edit,
        label: l10n.edit.sentenceCase,
        icon: HugeIcons.strokeRoundedEdit01,
      ),
  ];

  List<ClipboardContextMenuItem> _organizationActions(
    AppLocalizations l10n,
    ClipboardItem item,
  ) => [
    (
      action: ClipboardMenuAction.togglePin,
      label: item.isPinned ? l10n.unpin.sentenceCase : l10n.pin.sentenceCase,
      icon: item.isPinned
          ? HugeIcons.strokeRoundedPinOff
          : HugeIcons.strokeRoundedPin,
    ),
  ];

  List<ClipboardContextMenuItem> _destructiveActions(AppLocalizations l10n) => [
    (
      action: ClipboardMenuAction.deleteItem,
      label: l10n.delete.sentenceCase,
      icon: HugeIcons.strokeRoundedDelete01,
    ),
    (
      action: ClipboardMenuAction.clearHistory,
      label: l10n.clearClipboardHistory.sentenceCase,
      icon: HugeIcons.strokeRoundedDelete03,
    ),
  ];

  // --- UI building ----------------------------------------------------------

  List<Widget> getContextMenuItems({
    required AppLocalizations l10n,
    required ClipboardItem item,
    required BuildContext context,
  }) {
    final widgets = <Widget>[];

    void addItems(List<ClipboardContextMenuItem> items) {
      widgets.addAll(
        items.map(
          (menuItem) =>
              _buildMenuTile(context: context, l10n: l10n, menuItem: menuItem),
        ),
      );
    }

    addItems(_primaryActions(l10n, item));
    addItems(_organizationActions(l10n, item));

    // Divider before destructive actions
    widgets.add(
      const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Divider(height: .3),
      ),
    );

    addItems(_destructiveActions(l10n));

    return widgets;
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required AppLocalizations l10n,
    required ClipboardContextMenuItem menuItem,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Text(menuItem.label),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: HugeIcon(icon: menuItem.icon as List<List>),
      ),
      onTap: () {
        Navigator.pop(context);
        _handleAction(context: context, l10n: l10n, action: menuItem.action);
      },
    );
  }

  // --- Actions --------------------------------------------------------------

  void _handleAction({
    required BuildContext context,
    required AppLocalizations l10n,
    required ClipboardMenuAction action,
  }) {
    switch (action) {
      case ClipboardMenuAction.copyPath:
        Clipboard.setData(ClipboardData(text: clipboardItem.filePath ?? ''));
        return;

      case ClipboardMenuAction.openLink:
        launchUrl(Uri.parse(clipboardItem.content));
        return;

      case ClipboardMenuAction.togglePin:
        final isPro = context.read<EntitlementCubit>().state.isProActive;
        if (!isPro) {
          context.read<UpgradePromptCubit>().request(
            ProFeature.pinItems,
            source: ProFeatureRequestSource.pinButton,
          );
          return;
        }

        context.read<ClipboardDetailCubit>().togglePinClipboardItem(
          clipboardItem,
        );
        return;

      case ClipboardMenuAction.deleteItem:
        context.read<ClipboardDetailCubit>().deleteClipboardItem(clipboardItem);
        return;

      case ClipboardMenuAction.appendToClipboard:
        context.read<ClipboardCubit>().copyToClipboard(clipboardItem);
        return;

      case ClipboardMenuAction.clearHistory:
        context.read<ClipboardCubit>().clearClipboard();
        return;

      case ClipboardMenuAction.edit:
        // TODO(Ethiel97): Handle edit action
        return;
    }
  }

  // --- Widget ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) => ContextMenuArea(
    builder: (innerContext) => [
      ...getContextMenuItems(
        l10n: context.l10n,
        item: clipboardItem,
        context: context,
      ),
    ],
    verticalPadding: AppSpacing.sm,
    child: child,
  );
}

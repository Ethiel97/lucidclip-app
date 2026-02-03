import 'package:auto_route/auto_route.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

enum ClipboardMenuAction {
  pasteToApp,
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

class ClipboardContextMenu extends StatefulWidget {
  const ClipboardContextMenu({
    required this.child,
    required this.clipboardItem,
    super.key,
  });

  final Widget child;
  final ClipboardItem clipboardItem;

  @override
  State<ClipboardContextMenu> createState() => _ClipboardContextMenuState();
}

class _ClipboardContextMenuState extends State<ClipboardContextMenu> {
  // Duration to wait for clipboard to be synchronized with system clipboard
  static const _clipboardSyncDelay = Duration(milliseconds: 100);
  
  // --- Sections -------------------------------------------------------------

  List<ClipboardContextMenuItem> _primaryActions(
    AppLocalizations l10n,
    ClipboardItem item,
  ) {
    final sourceApp = item.sourceApp;
    return [
      if (sourceApp != null && sourceApp.isValid)
        (
          action: ClipboardMenuAction.pasteToApp,
          label: '${l10n.pasteTo} ${sourceApp.name}',
          icon: sourceApp,
        ),
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
  }

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
        child: Divider(height: .2, thickness: .2),
      ),
    );

    addItems(_destructiveActions(l10n));

    return widgets;
  }

  Future<void> _handlePasteToApp(BuildContext context) async {
    final sourceApp = widget.clipboardItem.sourceApp;
    if (sourceApp == null || !sourceApp.isValid) {
      return;
    }

    final pasteService = context.read<PasteToAppService>();
    
    // Check if we have accessibility permission
    final hasPermission = await pasteService.checkAccessibilityPermission();
    
    if (!hasPermission) {
      // Request permission
      final granted = await pasteService.requestAccessibilityPermission();
      if (!granted) {
        // Show error or message
        return;
      }
    }
    
    // Copy the clipboard item to system clipboard first
    context.read<ClipboardCubit>().copyToClipboard(widget.clipboardItem);
    
    // Wait for clipboard to be synchronized
    await Future.delayed(_clipboardSyncDelay);
    
    // Paste to the source app
    await pasteService.pasteToApp(sourceApp.bundleId);
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required AppLocalizations l10n,
    required ClipboardContextMenuItem menuItem,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Text(menuItem.label),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: menuItem.icon is SourceApp
            ? (menuItem.icon as SourceApp).getIconWidget(colorScheme)
            : HugeIcon(icon: menuItem.icon as List<List>),
      ),
      onTap: () {
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleAction(context: context, l10n: l10n, action: menuItem.action);
        });
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
      case ClipboardMenuAction.pasteToApp:
        _handlePasteToApp(context);
        return;

      case ClipboardMenuAction.copyPath:
        Clipboard.setData(ClipboardData(text: widget.clipboardItem.filePath ?? ''));
        return;

      case ClipboardMenuAction.openLink:
        launchUrl(Uri.parse(widget.clipboardItem.content));
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
          widget.clipboardItem,
        );
        return;

      case ClipboardMenuAction.deleteItem:
        context.read<ClipboardDetailCubit>().deleteClipboardItem(widget.clipboardItem);
        return;

      case ClipboardMenuAction.appendToClipboard:
        context.read<ClipboardCubit>().copyToClipboard(widget.clipboardItem);
        return;

      case ClipboardMenuAction.clearHistory:
        context.read<ClipboardCubit>().clearClipboard();
        return;

      case ClipboardMenuAction.edit:
        context.read<ClipboardDetailCubit>().setClipboardItem(widget.clipboardItem);
        context.router.root.push(
          ClipboardEditRoute(clipboardItem: widget.clipboardItem),
        );
        return;
    }
  }

  @override
  Widget build(BuildContext context) => ContextMenuArea(
    builder: (innerContext) => [
      ...getContextMenuItems(
        l10n: context.l10n,
        item: widget.clipboardItem,
        context: context,
      ),
    ],
    verticalPadding: AppSpacing.sm,
    child: widget.child,
  );
}

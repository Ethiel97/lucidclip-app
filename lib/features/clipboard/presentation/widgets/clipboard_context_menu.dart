import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/data/data.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/arb/app_localizations.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

typedef ClipboardContextMenuItem = ({String label, Object icon});

class ClipboardContextMenu extends StatelessWidget {
  const ClipboardContextMenu({
    required this.child,
    required this.clipboardItem,
    super.key,
  });

  final Widget child;
  final ClipboardItem clipboardItem;

  List<Widget> getContextMenuItems({
    required AppLocalizations l10n,
    required ClipboardItem item,
    required BuildContext context,
  }) {
    final menu = <ClipboardContextMenuItem>[
      // TODO(Ethiel97): the pin feature is for PRO users only,
      //  hide it for free users
      (
        label: item.isPinned ? l10n.unpin : l10n.pin.sentenceCase,
        icon: item.isPinned
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
                    clipboardItem,
                  );
                case final l when l == l10n.delete.sentenceCase:
                  context.read<ClipboardDetailCubit>().deleteClipboardItem(
                    clipboardItem,
                  );
                case final l when l == l10n.edit.sentenceCase:
                  // TODO(Ethiel97): Handle edit action
                  break;
                case final l when l == l10n.copy.sentenceCase:
                  getIt<BaseClipboardManager>().setClipboardContent(
                    clipboardItem.toInfrastructure(),
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
  Widget build(BuildContext context) => ContextMenuArea(
    builder: (context) => getContextMenuItems(
      l10n: context.l10n,
      item: clipboardItem,
      context: context,
    ),
    verticalPadding: AppSpacing.sm,
    child: child,
  );
}

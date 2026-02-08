import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.xs,
      children: [
        Expanded(child: SearchField()),
        ClipboardItemTypeFilter(),
        IncognitoModeToggleButton(),
        /* ProGateOverlay(
          badgeOffset: const Offset(32, -14),
          onUpgradeTap: () {
            context.read<UpgradePromptCubit>().request(ProFeature.autoSync);
          },
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            onPressed: () async {
              //TODO(Ethiel): Implement sync functionality
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedDatabaseSync01,
              size: 18,
            ),
            label: Text(l10n.sync.sentenceCase),
          ),
        ),*/
      ],
    );
  }
}

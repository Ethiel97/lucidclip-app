import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.xs,
      children: [
        const Expanded(child: SearchField()),
        const ClipboardItemTypeFilter(),
        const IncognitoModeToggleButton(),
        ProGateOverlay(
          onUpgradeTap: () {
            context.read<UpgradePromptCubit>().request(ProFeature.autoSync);
          },
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            onPressed: () async {
              /*  final isAuthorized = await ensureProAccess(
                context: context,
                source: ProFeatureRequestSource.autoSync,
                feature: ProFeature.autoSync,
              );
              if (!isAuthorized) return;*/

              //TODO(Ethiel): Implement sync functionality
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedDatabaseSync01,
              size: 18,
            ),
            label: Text(l10n.sync.sentenceCase),
          ),
        ),
      ],
    );
  }
}

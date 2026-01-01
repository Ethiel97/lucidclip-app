import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

// TODO(Ethiel97): Add SearchField here

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.md,
      children: [
        const Expanded(
          child: SearchField(),
        ),
        IconButton(
          onPressed: () {},
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedFilter),
        ),

        FilledButton.icon(
          onPressed: () {},
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedFileSync),
          label: Text(l10n.sync.sentenceCase),
        ),
      ],
    );
  }
}

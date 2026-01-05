import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ClipboardView extends StatelessWidget {
  const ClipboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (pinnedItems, recentItems) = context.select(
      (ClipboardCubit cubit) =>
          (cubit.state.pinnedItems, cubit.state.unPinnedItems),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xlg,
        AppSpacing.lg,
        AppSpacing.xlg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(),
          /* const SizedBox(height: AppSpacing.md),
          const _SearchField(),*/
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Scrollbar(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  if (pinnedItems.isNotEmpty) ...[
                     SectionHeader(title: l10n.pinned.sentenceCase),
                    ...pinnedItems.map(
                      (i) => ClipboardItemTile(item: i),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                   SectionHeader(title: l10n.recent.sentenceCase),
                  const SizedBox(height: AppSpacing.xs),
                  ...recentItems.map(
                    (i) => ClipboardItemTile(item: i),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

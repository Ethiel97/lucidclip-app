import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ClipboardPage extends StatelessWidget {
  const ClipboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClipboardCubit>(),
      child: const ClipboardView(),
    );
  }
}

class ClipboardView extends StatefulWidget {
  const ClipboardView({super.key});

  @override
  State<ClipboardView> createState() => _ClipboardViewState();
}

class _ClipboardViewState extends State<ClipboardView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (pinnedItems, recentItems) = context.select(
      (ClipboardCubit cubit) =>
          (cubit.state.pinnedItems, cubit.state.unpinnedItems),
    );

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Padding(
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
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (pinnedItems.isNotEmpty) ...[
                            ClipboardListRenderer(
                              items: pinnedItems,
                              title: l10n.pinned,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],

                          ClipboardListRenderer(
                            items: recentItems,
                            title: l10n.recent,
                          ),
                        ],
                      ),
                    ),
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

class ClipboardListRenderer extends StatelessWidget {
  const ClipboardListRenderer({
    required this.items,
    required this.title,
    super.key,
  });

  final ClipboardItems items;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionHeader(title: title.sentenceCase),
        const SizedBox(height: AppSpacing.xs),

        if (items.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.md,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClipboard,
                size: AppSpacing.xxxxxlg * 2,
                color: AppColors.textMuted,
              ),
              Text(
                context.l10n.noItemsForCategory(title.sentenceCase),
                style: AppTextStyle.functionalSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          )
        else
          ...items.map((i) => ClipboardItemTile(item: i)),
      ],
    );
  }
}

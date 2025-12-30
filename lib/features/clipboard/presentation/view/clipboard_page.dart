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
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<ClipboardCubit>()),
      BlocProvider(create: (_) => getIt<ClipboardDetailCubit>()),
    ],
    child: const ClipboardView(),
  );
}

class ClipboardView extends StatefulWidget {
  const ClipboardView({super.key});

  @override
  State<ClipboardView> createState() => _ClipboardViewState();
}

class _ClipboardViewState extends State<ClipboardView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final clipboardItemDetailsSlideDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;
  late final Animation<Offset> _clipboardItemDetailsSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _clipboardItemDetailsSlideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (pinnedItems, recentItems) = context.select(
      (ClipboardCubit cubit) =>
          (cubit.state.pinnedItems, cubit.state.unpinnedItems),
    );

    final selectedClipboardItem = context.select(
      (ClipboardDetailCubit cubit) => cubit.state.clipboardItem,
    );

    final hasClipboardItem = context.select(
      (ClipboardDetailCubit cubit) => cubit.state.hasClipboardItem,
    );

    return BlocListener<ClipboardDetailCubit, ClipboardDetailState>(
      listener: (context, state) {
        if (state.clipboardItem != null && state.hasClipboardItem) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Row(
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

            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topRight,
                  child: SlideTransition(
                    position: _clipboardItemDetailsSlideAnimation,
                    child: ClipboardItemDetailsView(
                      clipboardItem:
                          selectedClipboardItem?.value ?? ClipboardItem.empty(),
                      onClose: () {
                        context.read<ClipboardDetailCubit>().clearSelection();
                      },
                      onTogglePin: () {
                        if (hasClipboardItem) {
                          context
                              .read<ClipboardDetailCubit>()
                              .togglePinClipboardItem(
                                selectedClipboardItem!.data,
                              );

                          context.read<ClipboardDetailCubit>().clearSelection();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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

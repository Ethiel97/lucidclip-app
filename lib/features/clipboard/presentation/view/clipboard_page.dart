import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

typedef ClipboardPageItems = (
  ClipboardItems pinnedItems,
  ClipboardItems recentItems,
);

@RoutePage()
class ClipboardPage extends StatelessWidget {
  const ClipboardPage({super.key});

  @override
  Widget build(BuildContext context) => const ClipboardView();
}

class ClipboardView extends StatefulWidget {
  const ClipboardView({super.key});

  @override
  State<ClipboardView> createState() => _ClipboardViewState();
}

class _ClipboardViewState extends State<ClipboardView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<Offset> _clipboardItemDetailsSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _clipboardItemDetailsSlideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  ClipboardPageItems getListItems(BuildContext context) {
    final (pinnedItems, recentItems) = context.select(
      (ClipboardCubit cubit) =>
          (cubit.state.pinnedItems, cubit.state.unPinnedItems),
    );

    final (isSearchMode, pinnedSearchResults, recentSearchResults) = context
        .select(
          (SearchCubit cubit) => (
            cubit.state.isSearchMode,
            cubit.state.pinnedItems,
            cubit.state.unPinnedItems,
          ),
        );

    if (isSearchMode) {
      return (pinnedSearchResults, recentSearchResults);
    }

    return (pinnedItems, recentItems);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final selectedClipboardItem = context.select(
      (ClipboardDetailCubit cubit) => cubit.state.clipboardItem,
    );

    final hasClipboardItem = context.select(
      (ClipboardDetailCubit cubit) => cubit.state.hasClipboardItem,
    );

    final isSearchMode = context.select(
      (SearchCubit cubit) => cubit.state.isSearchMode,
    );

    final (pinnedItems, recentItems) = getListItems(context);

    final allItems = [
      if (pinnedItems.isNotEmpty)
        SectionHeader(title: l10n.pinned.sentenceCase),
      ...pinnedItems,
      if (recentItems.isNotEmpty)
        SectionHeader(title: l10n.recent.sentenceCase),
      ...recentItems,
    ];

    return MultiBlocListener(
      listeners: [
        BlocListener<ClipboardDetailCubit, ClipboardDetailState>(
          listenWhen: (previous, current) =>
              previous.hasClipboardItem != current.hasClipboardItem,
          listener: (context, state) {
            if (state.hasClipboardItem) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            // Static list view - never rebuilds during animation
            AbsorbPointer(
              absorbing: hasClipboardItem,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        controller: _scrollController,
                        itemCount: allItems.length,
                        itemExtent: 65, // 60px height + 12px margin = fixed extent
                        addAutomaticKeepAlives: false,
                        cacheExtent: 200,
                        itemBuilder: (context, index) {
                          final item = allItems[index];
                          if (item is SectionHeader) {
                            return item;
                          } else if (item is ClipboardItem) {
                            return ClipboardItemTile(
                              item: item,
                              key: ValueKey(item.id),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated overlay and details panel
            // if (hasClipboardItem)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final blocking = _animationController.value > 0.0;

                return CustomBarrier(
                  blocking: blocking,
                  onDismiss: () {
                    context.read<ClipboardDetailCubit>().clearSelection();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SlideTransition(
                      position: _clipboardItemDetailsSlideAnimation,
                      child: child,
                    ),
                  ),
                );
              },
              child: ClipboardItemDetailsView(
                clipboardItem:
                    selectedClipboardItem?.value ?? ClipboardItem.empty(),
                onClose: () {
                  context.read<ClipboardDetailCubit>().clearSelection();
                },
                onDelete: () {
                  if (hasClipboardItem) {
                    context.read<ClipboardDetailCubit>().clearSelection();

                    final clipboardItem = selectedClipboardItem!.data;
                    context.read<ClipboardDetailCubit>().deleteClipboardItem(
                      clipboardItem,
                    );
                  }
                },
                onTogglePin: () {
                  if (hasClipboardItem) {
                    context.read<ClipboardDetailCubit>().togglePinClipboardItem(
                      selectedClipboardItem!.data,
                    );
                  }
                },
              ),
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
    this.searchMode = false,
    super.key,
  });

  final ClipboardItems items;
  final bool searchMode;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionHeader(title: title.sentenceCase),
        const SizedBox(height: AppSpacing.xs),

        if (items.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.lg,
            children: [
              HugeIcon(
                icon: searchMode
                    ? HugeIcons.strokeRoundedSearchVisual
                    : HugeIcons.strokeRoundedClipboard,
                size: AppSpacing.xxxxxlg * 2,
                color: colorScheme.primary,
              ),
              Text(
                context.l10n.noItemsForCategory(title.sentenceCase),
                style: AppTextStyle.functionalSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
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

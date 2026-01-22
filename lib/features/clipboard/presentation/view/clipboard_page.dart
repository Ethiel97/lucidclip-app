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

    final searchFilterType = context.select(
      (SearchCubit cubit) => cubit.state.filterType,
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
                      child: allItems.isEmpty
                          ? Center(
                              child: _EmptyStateWidget(
                                searchMode: isSearchMode,
                                key: const ValueKey('pinned_empty'),
                              ),
                            )
                          : ListView.builder(
                              // key: ValueKey(value)
                              key: ValueKey(
                                'list_${isSearchMode}_$searchFilterType',
                              ),

                              physics: const BouncingScrollPhysics(
                                parent: ClampingScrollPhysics(),
                              ),

                              itemCount: allItems.length,
                              addAutomaticKeepAlives: false,
                              cacheExtent: 200,
                              findChildIndexCallback: (Key key) {
                                if (key is ValueKey<String>) {
                                  final id = key.value;

                                  return allItems.indexWhere(
                                    (item) =>
                                        item is ClipboardItem && item.id == id,
                                  );
                                }
                                return null;
                              },
                              itemBuilder: (context, index) {
                                final item = allItems[index];

                                return switch (item) {
                                  SectionHeader() => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.md,
                                    ),
                                    child: item,
                                  ),

                                  ClipboardItem() => ClipboardItemTile(
                                    key: ValueKey(item.id),
                                    item: item,
                                  ),
                                  _ => const SizedBox.shrink(),
                                };
                              },
                            ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
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
                onCopyPressed: () {
                  if (hasClipboardItem) {
                    final clipboardItem = selectedClipboardItem!.data;
                    context.read<ClipboardCubit>().copyToClipboard(
                      clipboardItem,
                    );
                  }
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

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({required this.searchMode, super.key});

  final bool searchMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.lg,
      children: [
        HugeIcon(
          icon: searchMode
              ? HugeIcons.strokeRoundedSearchArea
              : HugeIcons.strokeRoundedClipboard,
          size: AppSpacing.xxxxlg * 2.8,
          color: colorScheme.onSurface,
        ),
        Text(
          searchMode
              ? context.l10n.noResultsFound
              : context.l10n.yourClipboardItemsWillAppearHere,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:tinycolor2/tinycolor2.dart';

class SidebarItemConfig<T> {
  const SidebarItemConfig({
    required this.icon,
    required this.label,
    required this.route,
  });

  final T icon;
  final String label;
  final PageRouteInfo route;
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late List<SidebarItemConfig<List<List<dynamic>>>> menuItems =
      <SidebarItemConfig<List<List<dynamic>>>>[];

  TabsRouter? _tabsRouter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tabsRouter = context.tabsRouter;
      _tabsRouter?.addListener(_handleRouteChange);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    menuItems = [
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedClipboard,
        label: context.l10n.clipboard.titleCase,
        route: const ClipboardRoute(),
      ),
      //TODO(Ethiel): Enable snippets when feature is ready
      /*SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedNote,
        label: context.l10n.snippets.titleCase,
        route: const SnippetsRoute(),
      ),*/
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedUserAccount,
        label: context.l10n.account.titleCase,
        route: const AccountRoute(),
      ),
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedSettings03,
        label: context.l10n.settings.titleCase,
        route: SettingsRoute(),
      ),
    ];
  }

  @override
  void dispose() {
    _tabsRouter?.removeListener(_handleRouteChange);
    super.dispose();
  }

  void _handleRouteChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final clipboardItemsCount = context.select<ClipboardCubit, int>(
      (cubit) => cubit.state.totalItemsCount,
    );
    final clipboardHistoryCapacity = context.select(
      (SettingsCubit cubit) => cubit.state.maxHistoryItems,
    );

    final isExpanded = context.select((SidebarCubit cubit) => cubit.state);

    final tabsRouter = context.tabsRouter;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
      width: isExpanded
          ? AppConstants.clipboardSidebarWidth
          : AppConstants.collapsedSidebarWidth,
      color: colorScheme.surface.toTinyColor().darken().color,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xlg),
          SizedBox(
            height: 40,
            child: ClipRect(
              child: Row(
                mainAxisAlignment: isExpanded
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (isExpanded) const Flexible(child: AppLogo()),
                  const _SidebarToggleButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
          Expanded(
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: menuItems.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = tabsRouter.activeIndex == index;

                return SidebarItem(
                  icon: HugeIcon(icon: item.icon),
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => tabsRouter.setActiveIndex(index),
                );
              },
            ),
          ),
          StorageIndicator(
            used: clipboardItemsCount,
            total: clipboardHistoryCapacity,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _SidebarToggleButton extends StatelessWidget {
  const _SidebarToggleButton();

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.select((SidebarCubit cubit) => cubit.state);

    return IconButton(
      onPressed: () {
        context.read<SidebarCubit>().toggle();
      },
      icon: HugeIcon(
        icon: isExpanded
            ? HugeIcons.strokeRoundedSidebarLeft
            : HugeIcons.strokeRoundedSidebarRight,
      ),
    );
  }
}

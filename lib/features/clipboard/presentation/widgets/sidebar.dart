import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/core/routes/app_routes.gr.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

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
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final clipboardItemsCount = context.select<ClipboardCubit, int>(
      (cubit) => cubit.state.totalItemsCount,
    );

    final menuItems = [
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedClipboard,
        label: l10n.clipboard.titleCase,
        route: const ClipboardRoute(),
      ),
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedNote,
        label: l10n.snippets.titleCase,
        route: const SnippetsRoute(),
      ),
      SidebarItemConfig<List<List<dynamic>>>(
        icon: HugeIcons.strokeRoundedSettings03,
        label: l10n.settings.titleCase,
        route: const SettingsRoute(),
      ),
    ];

    return Container(
      width: AppConstants.clipboardSidebarWidth,
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xlg),
          const AppLogo(), // Votre widget de logo
          const SizedBox(height: AppSpacing.xlg),
          Expanded(
            child: ListView.separated(
              itemCount: menuItems.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = context.router.isRouteActive(
                  item.route.routeName,
                );

                return SidebarItem(
                  icon: HugeIcon(icon: item.icon, size: 20),
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => context.navigateTo(item.route),
                );
              },
            ),
          ),
          StorageIndicator(used: clipboardItemsCount, total: 1000),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

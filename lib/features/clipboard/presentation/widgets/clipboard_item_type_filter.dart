import 'package:auto_route/auto_route.dart';
import 'package:flexible_dropdown/flexible_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ClipboardItemTypeFilter extends StatelessWidget {
  const ClipboardItemTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedFilterType = context.select(
      (SearchCubit cubit) => cubit.state.filterType,
    );
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final colorScheme = Theme.of(context).colorScheme;

    final entries =
        [
              FilterType.unknown,
              FilterType.text,
              FilterType.url,
              FilterType.image,
              FilterType.file,
            ]
            .map(
              (filterType) => InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs,
                    horizontal: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          filterType.filterTypeLabel(l10n).titleCase,
                          style: textStyle?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      if (filterType == selectedFilterType) ...[
                        const SizedBox(width: 8),
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                          color: AppColors.success,
                        ),
                      ],
                    ],
                  ),
                ),
                onTap: () {
                  final cubit = context.read<SearchCubit>();
                  context.pop();
                  cubit.setFilterType(filterType);
                },
              ),
            )
            .toList();

    return FlexibleDropdown(
      duration: const Duration(milliseconds: 100),
      animationType: AnimationType.fade,
      overlayChild: Material(
        color: colorScheme.surface.toTinyColor().darken(5).color,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(
            spacing: AppSpacing.sm,
            mainAxisSize: MainAxisSize.min,
            children: entries,
          ),
        ),
      ),
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedFilter,
        color: colorScheme.onSurface,
      ),
    );
  }
}

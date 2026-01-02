import 'package:flexible_dropdown/flexible_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ClipboardItemTypeFilter extends StatelessWidget {
  const ClipboardItemTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedFilterType = context.select(
      (SearchCubit cubit) => cubit.state.filterType,
    );
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
                        child: Text(filterType.filterTypeLabel(l10n).titleCase),
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
                  context.read<SearchCubit>().setFilterType(filterType);
                  Navigator.pop(context);
                },
              ),
            )
            .toList();

    return FlexibleDropdown(
      animationType: AnimationType.fade,
      overlayChild: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(mainAxisSize: MainAxisSize.min, children: entries),
        ),
      ),
      child: const HugeIcon(icon: HugeIcons.strokeRoundedFilter),
    );
  }
}

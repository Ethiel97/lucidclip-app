// import 'package:auto_route/auto_route.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class PageHeader extends StatefulWidget {
  const PageHeader({super.key});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final entries = [
      ...[
        FilterType.text,
        FilterType.image,
        FilterType.file,
        FilterType.url,
      ].map(
        (filterType) => ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(filterType.filterTypeLabel(l10n).titleCase),
          ),

          onTap: () {
            context.read<SearchCubit>().setFilterType(filterType);
            // context.pop();
          },
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.md,
      children: [
        const Expanded(child: SearchField()),
        ContextMenuArea(
          builder: (context) => entries,
          child: const HugeIcon(icon: HugeIcons.strokeRoundedFilter),
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

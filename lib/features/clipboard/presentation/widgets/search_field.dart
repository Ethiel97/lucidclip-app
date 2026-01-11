import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
        ),
      ),
      child: BlocListener<SearchCubit, SearchState>(
        listenWhen: (previous, current) =>
            previous.isSearchMode != current.isSearchMode,
        listener: (context, state) {
          if (!state.isSearchMode) {
            _controller.clear();
          }
        },
        child: TextFormField(
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          controller: _controller,
          onChanged: (value) {
            _debouncer.run(() {
              context.read<SearchCubit>().search(value);
            });
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: AppSpacing.md,
            ),
            hintText: l10n.searchHint.sentenceCase,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                context.read<SearchCubit>().clear();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm),
                child: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
              ),
            ),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }
}

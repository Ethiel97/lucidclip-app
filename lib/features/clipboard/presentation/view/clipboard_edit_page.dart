import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

@RoutePage()
class ClipboardEditPage extends StatefulWidget implements AutoRouteWrapper {
  const ClipboardEditPage({required this.clipboardItem, super.key});

  final ClipboardItem clipboardItem;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ClipboardDetailCubit>(),
      child: this,
    );
  }

  @override
  State<ClipboardEditPage> createState() => _ClipboardEditPageState();
}

class _ClipboardEditPageState extends State<ClipboardEditPage> {
  late final TextEditingController _controller;
  late final String _initialContent;

  @override
  void initState() {
    super.initState();
    _initialContent = widget.clipboardItem.content;
    _controller = TextEditingController(text: _initialContent);
    _controller.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClipboardDetailCubit>().setClipboardItem(
        widget.clipboardItem,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final current = _controller.text.trim();
    return current.isNotEmpty && current != _initialContent.trim();
  }

  void _handleSave() {
    context.read<ClipboardDetailCubit>().editClipboardItem(
      clipboardItem: widget.clipboardItem,
      updatedContent: _controller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ClipboardDetailCubit, ClipboardDetailState>(
      listenWhen: (previous, current) =>
          previous.editStatus?.status != current.editStatus?.status,
      listener: (context, state) {
        if (state.editStatus?.isSuccess ?? false) {
          context.read<ClipboardDetailCubit>().clearSelection();
          context.router.maybePop();

          return;
        }

        if (state.editStatus?.isError ?? false) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: SnackbarContent(
                  message: l10n.errorOccurred.sentenceCase,
                ),
              ),
            );
        }
      },
      buildWhen: (previous, current) =>
          previous.editStatus != current.editStatus,
      builder: (context, state) {
        final isSaving = state.editStatus?.isLoading ?? false;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
              onPressed: () {
                context.read<ClipboardDetailCubit>().clearSelection();
                context.router.maybePop();
              },
            ),
            title: Text(l10n.edit.sentenceCase),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: FilledButton.icon(
                  onPressed: _hasChanges && !isSaving ? _handleSave : null,
                  icon: isSaving
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : const HugeIcon(
                          icon: HugeIcons.strokeRoundedNoteEdit,
                          size: 16,
                        ),
                  label: Text(l10n.saveChanges.sentenceCase),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.clipContent.sentenceCase,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    widget.clipboardItem.resolveTypeBadge(l10n: l10n),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    maxLines: null,
                    minLines: 12,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: l10n.clipContent.sentenceCase,
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) {
                      return Text(
                        '${l10n.characters.sentenceCase}: ${value.text.length}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

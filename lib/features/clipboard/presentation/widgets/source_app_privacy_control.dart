import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class SourceAppPrivacyControl extends StatelessWidget {
  const SourceAppPrivacyControl({required this.clipboardItem, super.key});

  final ClipboardItem clipboardItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final excludedApps = context.select(
      (SettingsCubit cubit) => cubit.state.settings.value?.excludedApps ?? [],
    );

    final isSourceAppExcluded = clipboardItem.getIsSourceAppExcluded(
      excludedApps,
    );

    return TextButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isSourceAppExcluded
                    ? l10n.resumeTrackingAppConfirmation(
                        clipboardItem.sourceApp?.name ?? '',
                      )
                    : l10n.stopTrackingAppConfirmation(
                        clipboardItem.sourceApp?.name ?? '',
                      ),
              ),
              action: SnackBarAction(
                label: l10n.confirm.sentenceCase,
                onPressed: () {
                  context.read<SettingsCubit>().toggleAppExclusion(
                    clipboardItem.sourceApp,
                  );
                },
              ),
            ),
          );
      },
      child: Text(
        isSourceAppExcluded
            ? l10n.resumeTrackingApp(clipboardItem.sourceApp?.name ?? '')
            : l10n.stopTrackingApp(clipboardItem.sourceApp?.name ?? ''),
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: colorScheme.onSurface.withValues(alpha: 0.95),
        ),
      ),
    );
  }
}

class ExcludedSourceAppBadge extends StatelessWidget {
  const ExcludedSourceAppBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return ClipboardBadge(
      label: l10n.excluded.sentenceCase,
      color: colorScheme.error.withValues(alpha: .75),
    );
  }
}

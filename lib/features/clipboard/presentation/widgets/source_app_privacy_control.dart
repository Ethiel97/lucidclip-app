import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:toastification/toastification.dart';

class SourceAppPrivacyControl extends StatelessWidget {
  const SourceAppPrivacyControl({required this.clipboardItem, super.key});

  final ClipboardItem clipboardItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final settings = context.select(
      (SettingsCubit cubit) => cubit.state.settings.value!,
    );

    final isExcluded = settings.excludedApps.contains(
      clipboardItem.sourceApp?.bundleId,
    );

    // print("bundleId: ${clipboardItem.sourceApp?.bundleId }");

    // print("Excluded Apps: ${settings.excludedApps}");

    return MultiBlocListener(
      listeners: [
        BlocListener<ClipboardCubit, ClipboardState>(
          listenWhen: (previous, current) =>
              previous.excludeAppResult != current.excludeAppResult,
          listener: (context, state) {
            if (state.excludeAppResult.isSuccess) {
              final appName = state.excludeAppResult.data;
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(l10n.appNoLongerTracked(appName)),
                description: Text(l10n.appNoLongerTrackedDescription(appName)),
                autoCloseDuration: const Duration(seconds: 10),
              );
            }

            context.read<ClipboardDetailCubit>().clearSelection();
          },
        ),

        BlocListener<ClipboardCubit, ClipboardState>(
          listenWhen: (previous, current) =>
              previous.includeAppResult != current.includeAppResult,
          listener: (context, state) {
            if (state.includeAppResult.isSuccess) {
              final appName = state.includeAppResult.data;
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(l10n.trackingResumedForApp(appName)),
                description: Text(
                  l10n.trackingResumedForAppDescription(appName),
                ),
                autoCloseDuration: const Duration(seconds: 10),
              );
            }

            context.read<ClipboardDetailCubit>().clearSelection();
          },
        ),
      ],
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
          foregroundColor: colorScheme.onPrimary.withValues(alpha: 0.75),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(8),
          // ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  isExcluded
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
                    context.read<ClipboardCubit>().toggleAppExclusion(
                      clipboardItem,
                    );
                  },
                ),
              ),
            );
        },
        child: Text(
          isExcluded
              ? l10n.resumeTrackingApp(clipboardItem.sourceApp?.name ?? '')
              : l10n.stopTrackingApp(clipboardItem.sourceApp?.name ?? ''),
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: colorScheme.onPrimary.withValues(alpha: 0.75),
          ),
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

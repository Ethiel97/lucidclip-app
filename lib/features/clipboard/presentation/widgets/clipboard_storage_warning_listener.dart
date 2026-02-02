import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

const double _warningThresholdRatio = 0.9;

class ClipboardStorageWarningListener extends StatelessWidget {
  const ClipboardStorageWarningListener({
    required this.child,
    required this.isEntitlementLoaded,
    this.isProUser = false,
    this.onUpgradeTap,
    super.key,
  });

  final bool isEntitlementLoaded;
  final bool isProUser;
  final Widget child;
  final VoidCallback? onUpgradeTap;

  @override
  Widget build(BuildContext context) {
    if (!isEntitlementLoaded) {
      return child;
    }

    final l10n = context.l10n;
    final maxHistoryItems = context.select(
      (SettingsCubit cubit) => cubit.state.maxHistoryItems,
    );

    return MultiBlocListener(
      listeners: [
        SafeBlocListener<ClipboardCubit, ClipboardState>(
          listenWhen: (previous, current) {
            if (isProUser) return false;
            final previousRatio =
                (previous.clipboardItems.value?.length ?? 0) / maxHistoryItems;
            final currentRatio =
                (current.clipboardItems.value?.length ?? 0) / maxHistoryItems;

            return previousRatio < _warningThresholdRatio &&
                currentRatio >= _warningThresholdRatio;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 8),
                  persist: false,
                  content: SnackbarContent(
                    title: l10n.storageAlmostFull.sentenceCase,
                    message: l10n.storageAlmostFullDescription(
                      (_warningThresholdRatio * 100).toInt(),
                    ),
                  ),
                  action: onUpgradeTap != null
                      ? SnackBarAction(
                          label: l10n.upgradeToPro,
                          onPressed: onUpgradeTap!,
                        )
                      : null,
                ),
              );
          },
        ),

        SafeBlocListener<ClipboardCubit, ClipboardState>(
          listenWhen: (previous, current) {
            if (isProUser || maxHistoryItems <= 0) return false;

            final prevCount = previous.clipboardItems.value?.length ?? 0;
            final currCount = current.clipboardItems.value?.length ?? 0;

            if (currCount <= prevCount) return false;

            final wasBelowMax = prevCount < maxHistoryItems;
            final isNowAtOrAbove = currCount >= maxHistoryItems;

            return wasBelowMax && isNowAtOrAbove;
          },
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 8),
                  persist: false,
                  content: SnackbarContent(
                    title: l10n.clipboardFull.sentenceCase,
                    message: l10n.clipboardFullDescription.sentenceCase,
                  ),
                  action: onUpgradeTap != null
                      ? SnackBarAction(
                          label: l10n.upgradeToPro,
                          onPressed: onUpgradeTap!,
                        )
                      : null,
                ),
              );
          },
        ),
      ],
      child: child,
    );
  }
}

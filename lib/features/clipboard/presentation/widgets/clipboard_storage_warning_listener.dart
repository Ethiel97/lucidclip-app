import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

const double _warningThresholdRatio = 0.9;

class ClipboardSideEffects {
  static List<SafeBlocListener<ClipboardCubit, ClipboardState>> listeners() => [
    // Listener 1: "Storage Almost Full" warning at 90%
    SafeBlocListener<ClipboardCubit, ClipboardState>(
      listenWhen: (prev, curr) {
        // ✅ We have both previous and current states here
        final prevCount = prev.clipboardItems.value?.length ?? 0;
        final currCount = curr.clipboardItems.value?.length ?? 0;

        // Only trigger when count increases
        if (currCount <= prevCount) return false;

        // Get max from somewhere... but we don't have context here!
        // So we have to check the threshold in the listener instead
        return true;
      },
      listener: (context, state) {
        final isProUser = context.read<EntitlementCubit>().state.isProActive;
        if (isProUser) return;

        final maxHistoryItems = context
            .read<SettingsCubit>()
            .state
            .maxHistoryItems;
        if (maxHistoryItems <= 0) return;

        final currentCount = state.clipboardItems.value?.length ?? 0;
        final currentRatio = currentCount / maxHistoryItems;

        // Only show if:
        // 1. We're at or above 90% threshold
        // 2. We're NOT at 100% (that's handled by the "Full" listener)
        final atWarningThreshold = currentRatio >= _warningThresholdRatio;
        final notAtMax = currentCount < maxHistoryItems;

        if (!atWarningThreshold || !notAtMax) return;

        final l10n = context.l10n;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              showCloseIcon: true,
              duration: const Duration(seconds: 8),
              persist: false,
              content: SnackbarContent(
                title: l10n.storageAlmostFull.sentenceCase,
                message: l10n.storageAlmostFullDescription(
                  (_warningThresholdRatio * 100).toInt(),
                ),
              ),
              action: SnackBarAction(
                label: l10n.upgradeToPro,
                onPressed: () {
                  context.read<UpgradePromptCubit>().request(
                    ProFeature.unlimitedHistory,
                    source: ProFeatureRequestSource.historyLimitReached,
                  );
                },
              ),
            ),
          );
      },
    ),

    // Listener 2: "Storage Full" warning at 100%
    SafeBlocListener<ClipboardCubit, ClipboardState>(
      listenWhen: (previous, current) {
        final prevCount = previous.clipboardItems.value?.length ?? 0;
        final currCount = current.clipboardItems.value?.length ?? 0;

        // Only trigger when count increases
        return currCount > prevCount;
      },
      listener: (context, state) {
        final isProUser = context.read<EntitlementCubit>().state.isProActive;
        if (isProUser) return;

        final maxHistoryItems = context
            .read<SettingsCubit>()
            .state
            .maxHistoryItems;
        if (maxHistoryItems <= 0) return;

        final currentCount = state.clipboardItems.value?.length ?? 0;

        // Only show if we're at or above max
        if (currentCount < maxHistoryItems) return;

        final l10n = context.l10n;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              showCloseIcon: true,
              duration: const Duration(seconds: 8),
              persist: false,
              content: SnackbarContent(
                title: l10n.clipboardFull.sentenceCase,
                message: l10n.clipboardFullDescription.sentenceCase,
              ),
              action: SnackBarAction(
                label: l10n.upgradeToPro,
                onPressed: () {
                  context.read<UpgradePromptCubit>().request(
                    ProFeature.unlimitedHistory,
                    source: ProFeatureRequestSource.historyLimitReached,
                  );
                },
              ),
            ),
          );
      },
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:toastification/toastification.dart';

class EntitlementSideEffects {
  static List<SafeBlocListener<EntitlementCubit, EntitlementState>>
  listeners() => [
    // listens to Pro activation to update settings
    // accordingly and show a welcome toast
    SafeBlocListener<EntitlementCubit, EntitlementState>(
      listenWhen: (prev, curr) => !prev.isProActive && curr.isProActive,
      listener: (context, state) {
        final l10n = context.l10n;
        final settingsCubit = context.read<SettingsCubit>();

        getIt<WindowController>().showAsOverlay().unawaited();
        Analytics.track(AnalyticsEvent.proActivated).unawaited();

        // ensure max history items is at least 5000 for Pro users
        if (settingsCubit.state.maxHistoryItems <
            MaxHistorySize.size5000.value) {
          settingsCubit.updateMaxHistoryItems(MaxHistorySize.size5000.value);
        }

        final retentionDuration = RetentionDuration.fromDays(
          settingsCubit.state.retentionDays,
        );

        // ensure retention days is at least 7 days for Pro users
        if (retentionDuration.duration.inDays <
            RetentionDuration.sevenDays.duration.inDays) {
          settingsCubit.updateRetentionDays(
            RetentionDuration.sevenDays.duration.inDays,
          );
        }

        //show a toast to welcome user to Pro
        toastification.show(
          context: context,
          type: ToastificationType.info,
          style: ToastificationStyle.minimal,
          title: Text(l10n.welcomeToPro),
          description: Text(l10n.youNowHavePro),
          autoCloseDuration: const Duration(seconds: 10),
        );
      },
    ),

    /// listens to Pro deactivation to update settings accordingly
    SafeBlocListener<EntitlementCubit, EntitlementState>(
      listenWhen: (prev, curr) => prev.isProActive && !curr.isProActive,
      listener: (context, state) {
        final settingsCubit = context.read<SettingsCubit>();

        // ensure max history items is at most 30 for free users
        if (settingsCubit.state.maxHistoryItems > MaxHistorySize.size30.value) {
          settingsCubit.updateMaxHistoryItems(MaxHistorySize.size30.value);
        }

        final retentionDuration = RetentionDuration.fromDays(
          settingsCubit.state.retentionDays,
        );

        // ensure retention days is at most 7 days for free users
        if (retentionDuration.duration.inDays >
            RetentionDuration.sevenDays.duration.inDays) {
          settingsCubit.updateRetentionDays(
            RetentionDuration.sevenDays.duration.inDays,
          );
        }
      },
    ),
  ];
}

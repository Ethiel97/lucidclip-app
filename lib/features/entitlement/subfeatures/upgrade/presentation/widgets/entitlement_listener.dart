import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:toastification/toastification.dart';

class EntitlementListener extends StatelessWidget {
  const EntitlementListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// listens to Pro activation to update settings accordingly
        SafeBlocListener<EntitlementCubit, EntitlementState>(
          listenWhen: (prev, curr) => !prev.isProActive && curr.isProActive,
          listener: (context, state) {
            final l10n = context.l10n;
            final settingsCubit = context.read<SettingsCubit>();
            if (settingsCubit.state.maxHistoryItems <
                MaxHistorySize.size5000.value) {
              settingsCubit.updateMaxHistoryItems(
                MaxHistorySize.size5000.value,
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
            if (settingsCubit.state.maxHistoryItems >
                MaxHistorySize.size30.value) {
              settingsCubit.updateMaxHistoryItems(MaxHistorySize.size30.value);
            }
          },
        ),
      ],
      child: child,
    );
  }
}

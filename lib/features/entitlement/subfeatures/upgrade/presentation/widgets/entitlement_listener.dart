import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';

class EntitlementListener extends StatelessWidget {
  const EntitlementListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// listens to Pro activation to update settings accordingly
        BlocListener<EntitlementCubit, EntitlementState>(
          listenWhen: (prev, curr) => !prev.isProActive && curr.isProActive,
          listener: (context, state) {
            final settingsCubit = context.read<SettingsCubit>();
            if (settingsCubit.state.maxHistoryItems <
                MaxHistorySize.size5000.value) {
              settingsCubit.updateMaxHistoryItems(
                MaxHistorySize.size5000.value,
              );
            }
          },
        ),

        /// listens to Pro deactivation to update settings accordingly
        BlocListener<EntitlementCubit, EntitlementState>(
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

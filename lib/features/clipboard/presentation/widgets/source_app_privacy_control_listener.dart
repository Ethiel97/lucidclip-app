import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:toastification/toastification.dart';

class SourceAppPrivacyControlListener extends StatelessWidget {
  const SourceAppPrivacyControlListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<ClipboardCubit, ClipboardState>(
          listenWhen: (previous, current) =>
              previous.excludeAppResult != current.excludeAppResult,
          listener: (context, state) {
            if (state.excludeAppResult.isSuccess) {
              final app = state.excludeAppResult.data;
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(l10n.appNoLongerTracked(app.name)),
                description: Text(l10n.appNoLongerTrackedDescription(app.name)),
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
              final app = state.includeAppResult.data;
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(l10n.trackingResumedForApp(app.name)),
                description: Text(
                  l10n.trackingResumedForAppDescription(app.name),
                ),
                autoCloseDuration: const Duration(seconds: 10),
              );
            }

            context.read<ClipboardDetailCubit>().clearSelection();
          },
        ),
      ],

      child: child,
    );
  }
}

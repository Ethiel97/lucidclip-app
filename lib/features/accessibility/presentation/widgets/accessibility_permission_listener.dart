import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';

class AccessibilityPermissionListener extends StatelessWidget {
  const AccessibilityPermissionListener({required this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      SafeBlocListener<AccessibilityCubit, AccessibilityState>(
        listenWhen: (previous, current) =>
            previous.showPermissionDialog != current.showPermissionDialog,
        listener: (context, state) async {
          if (state.showPermissionDialog) {
            await showDialog<void>(
              context: context,
              barrierColor: Colors.black.withValues(alpha: 0.55),
              builder: (_) => const AccessibilityPermissionDialog(),
            );
          }
        },
      ),

      SafeBlocListener<AccessibilityCubit, AccessibilityState>(
        listenWhen: (previous, current) =>
            previous.showPermissionDialog != current.showPermissionDialog ||
            previous.hasPermission != current.hasPermission,
        listener: (context, state) {
          if (state.showPermissionDialog) {
            getIt<WindowController>().setSafeAlwaysOnTop(alwaysOnTop: false);

            return;
          }

          if (!state.showPermissionDialog || state.hasPermission) {
            getIt<WindowController>().setSafeAlwaysOnTop();
          }
        },
      ),
    ],
    child: child ?? const SizedBox.shrink(),
  );
}

import 'package:flutter/material.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';

class AccessibilityPermissionListener extends StatelessWidget {
  const AccessibilityPermissionListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeBlocListener<AccessibilityCubit, AccessibilityState>(
      listenWhen: (previous, current) =>
          previous.showPermissionDialog != current.showPermissionDialog,
      listener: (context, state) async {
        if (state.showPermissionDialog) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withValues(alpha: 0.55),
            builder: (_) => const AccessibilityPermissionDialog(),
          );
        }
      },
      child: child,
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBarrier extends StatelessWidget {
  const CustomBarrier({
    required this.child,
    super.key,
    this.backgroundContent = const SizedBox.shrink(),
    this.blocking = false,
    this.blurValue = 5.0,
    this.onDismiss,
  });

  final Widget? backgroundContent;
  final Widget child;
  final bool blocking;
  final double blurValue;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: blocking,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
            child: backgroundContent,
          ),
        ),

        if (blocking)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: Container(color: colorScheme.scrim.withValues(alpha: .4)),
            ),
          ),

        child,
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CustomBarrier extends StatelessWidget {
  const CustomBarrier({
    required this.child,
    super.key,
    this.blocking = false,
    this.onDismiss,
  });

  final Widget child;
  final bool blocking;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        if (blocking)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: Container(color: colorScheme.scrim.withValues(alpha: .72)),
            ),
          ),

        child,
      ],
    );
  }
}

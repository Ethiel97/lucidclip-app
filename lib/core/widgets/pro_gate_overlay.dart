import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ProGateOverlay extends StatelessWidget {
  const ProGateOverlay({
    required this.child,
    this.isPro = false,
    this.onUpgradeTap,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.dimWhenLocked = true,
    this.blockInteractions = true,
    this.badgeScale = 0.72,
    this.badgeOffset = const Offset(16, -16),
    super.key,
  });

  final Widget child;
  final bool isPro;
  final VoidCallback? onUpgradeTap;
  final Alignment badgeAlignment;
  final EdgeInsets badgePadding;
  final bool dimWhenLocked;
  final bool blockInteractions;

  /// Controls badge size without magic numbers.
  final double badgeScale;

  /// Controls badge position relative to the aligned corner.
  final Offset badgeOffset;

  @override
  Widget build(BuildContext context) {
    if (isPro) return child;

    final lockedChild = dimWhenLocked
        ? Opacity(opacity: 0.55, child: child)
        : child;
    final gatedChild = blockInteractions
        ? AbsorbPointer(child: lockedChild)
        : lockedChild;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        gatedChild,
        Positioned.fill(
          child: Align(
            alignment: badgeAlignment,
            child: Transform.translate(
              offset: badgeOffset,
              child: Transform.scale(
                scale: badgeScale,
                child: Padding(
                  padding: badgePadding,
                  child: _ProBadgePill(onTap: onUpgradeTap),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProBadgePill extends StatelessWidget {
  const _ProBadgePill({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: 'Upgrade to Pro',
      child: MouseRegion(
        cursor: onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.95),
                    cs.secondary.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: cs.outline.withValues(alpha: 0.18)),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedCrown,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.pro.sentenceCase,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

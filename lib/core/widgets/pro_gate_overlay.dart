import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class ProGateOverlay extends StatelessWidget {
  const ProGateOverlay({
    required this.child,
    this.onUpgradeTap,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.dimWhenLocked = true,
    this.badgeScale = 0.5,
    this.badgeOffset = const Offset(12, -16),
    super.key,
  });

  final Widget child;

  /// Triggered when user attempts to access a Pro feature.
  final VoidCallback? onUpgradeTap;

  /// Badge placement.
  final Alignment badgeAlignment;
  final EdgeInsets badgePadding;

  /// Visual feedback when locked.
  final bool dimWhenLocked;

  /// Controls badge size.
  final double badgeScale;

  /// Controls badge position relative to alignment.
  final Offset badgeOffset;

  @override
  Widget build(BuildContext context) {
    final isPro = context.select(
      (EntitlementCubit cubit) => cubit.state.isProActive,
    );

    if (isPro) return child;

    final lockedChild = dimWhenLocked
        ? Opacity(opacity: 0.55, child: child)
        : child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockedChild,

        // ✅ Entire surface intercepts interaction
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Track overlay opened event
                Analytics.track(AnalyticsEvent.proGateOverlayOpened);
                onUpgradeTap?.call();
              },
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // ✅ Pro badge (always visible & clickable)
        Align(
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

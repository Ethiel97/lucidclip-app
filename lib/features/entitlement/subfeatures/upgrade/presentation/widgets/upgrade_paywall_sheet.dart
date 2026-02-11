import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class UpgradePaywallSheet extends StatefulWidget {
  const UpgradePaywallSheet({
    required this.feature,
    required this.monthlyProductId,
    required this.yearlyProductId,
    super.key,
  });

  final ProFeature feature;
  final String monthlyProductId;
  final String yearlyProductId;

  @override
  State<UpgradePaywallSheet> createState() => _UpgradePaywallSheetState();
}

class _UpgradePaywallSheetState extends State<UpgradePaywallSheet> {
  late ProPlan _selected;

  late final ProPlan _monthly = ProPlan(
    id: 'monthly',
    title: 'Lucid Pro — Monthly',
    subtitle: 'Unlock full clipboard control. Cancel anytime.',
    priceLabel: r'$6 / month',
    ctaLabel: 'Go Pro monthly',
    productId: widget.monthlyProductId,
  );

  late final ProPlan _yearly = ProPlan(
    id: 'yearly',
    title: 'Lucid Pro — Yearly',
    subtitle: 'Save 18%. Most popular choice!',
    priceLabel: r'$60 / year',
    ctaLabel: 'Go Pro yearly',
    productId: widget.yearlyProductId,
    badge: 'Best value',
  );

  @override
  void initState() {
    super.initState();
    _selected = _yearly; // default: best value
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final isStartingCheckout = context.select(
      (BillingCubit cubit) => cubit.state.checkout.isLoading,
    );

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: 520,
            padding: const EdgeInsets.all(AppSpacing.xlg),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(feature: widget.feature),
                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _PlanCard(
                        plan: _monthly,
                        selected: _selected.id == _monthly.id,
                        onTap: () => setState(() => _selected = _monthly),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PlanCard(
                        plan: _yearly,
                        selected: _selected.id == _yearly.id,
                        onTap: () => setState(() => _selected = _yearly),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.upgradePaywallSheetFooterSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FilledButton(
                      onPressed: () {
                        // Track upgrade clicked event
                        Analytics.track(
                          AnalyticsEvent.upgradeClicked,
                          UpgradeClickedParams(
                            source: _upgradeSourceFromContext(context),
                          ).toMap(),
                        ).unawaited();

                        context.read<BillingCubit>().startCheckout(
                          productId: _selected.productId,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      child: Row(
                        spacing: AppSpacing.sm,
                        children: [
                          if (isStartingCheckout)
                            const CircularProgressIndicator(),
                          Text(
                            isStartingCheckout
                                ? l10n.redirectingToSecureCheckout
                                : _selected.ctaLabel,
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCancel01,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.feature});

  final ProFeature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          feature.title(l10n),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          feature.description(l10n),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final ProPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.55)
                : colorScheme.outline.withValues(alpha: 0.68),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  plan.badge!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              plan.title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              plan.subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              plan.priceLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Get upgrade source from the current context
UpgradeSource _upgradeSourceFromContext(BuildContext context) {
  // Try to get the source from the UpgradePromptCubit state if available
  try {
    final state = context.read<UpgradePromptCubit>().state;
    final source = state.source;
    return mapProFeatureSourceToUpgradeSource(source);
  } catch (_) {
    return UpgradeSource.proGate;
  }
}

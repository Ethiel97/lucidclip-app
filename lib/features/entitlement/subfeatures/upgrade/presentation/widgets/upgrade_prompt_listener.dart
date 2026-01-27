import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/app/routes/app_routes.gr.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';

class UpgradePromptListener extends StatelessWidget {
  const UpgradePromptListener({
    required this.child,
    required this.monthlyProductId,
    required this.yearlyProductId,
    super.key,
  });

  final Widget child;
  final String monthlyProductId;
  final String yearlyProductId;

  @override
  Widget build(BuildContext context) {
    return SafeBlocListener<UpgradePromptCubit, UpgradePromptState>(
      listenWhen: (previous, current) =>
          previous.requestedFeature != current.requestedFeature,
      listener: (context, state) async {
        final feature = state.requestedFeature;
        if (feature == null) return;

        context.read<UpgradePromptCubit>().clearState();

        final isStartingCheckout = context.read<BillingCubit>().state.isLoading;
        final isAuthenticated = context.read<AuthCubit>().state.isAuthenticated;

        if (!isAuthenticated) {
          await context.router.root.navigate(const LoginRoute());
          return;
        }

        await showDialog<void>(
          context: context,
          barrierDismissible: !isStartingCheckout,
          barrierColor: Colors.black.withValues(alpha: 0.55),
          builder: (_) => Center(
            child: UpgradePaywallSheet(
              feature: feature,
              monthlyProductId: monthlyProductId,
              yearlyProductId: yearlyProductId,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

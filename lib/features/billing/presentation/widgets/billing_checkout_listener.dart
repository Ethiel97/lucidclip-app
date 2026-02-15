import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/billing/presentation/cubit/cubit.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingSideEffects {
  static List<SafeBlocListener<BillingCubit, BillingState>> listeners() => [
    SafeBlocListener<BillingCubit, BillingState>(
      listenWhen: (prev, curr) =>
          prev.checkout != curr.checkout && !curr.checkout.isInitial,
      listener: (context, state) async {
        // Open checkout URL if checkout is successful
        if (state.checkout.isSuccess) {
          final session = state.checkout.value;
          if (session == null) return;

          final url = Uri.tryParse(session.url);
          if (url != null) {
            await context.maybePop();
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }

        // Show error message if checkout failed
        if (state.checkout.isError) {
          final errorMessage = state.checkout.error?.message.toString();
          if (errorMessage != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
            }
          }
        }

        if (context.mounted) {
          context.read<BillingCubit>().clearCheckout();
        }
      },
    ),

    // Renew customer portal if expired
    SafeBlocListener<BillingCubit, BillingState>(
      listenWhen: (previous, current) =>
          previous.customerPortal != current.customerPortal &&
          current.needsPortalRenew,
      listener: (context, state) {
        //check if user has a valid pro entitlement
        final isProActive = context.read<EntitlementCubit>().state.isProActive;

        if (!isProActive) return;

        context.read<BillingCubit>().getCustomerPortal();
      },
    ),
  ];
}

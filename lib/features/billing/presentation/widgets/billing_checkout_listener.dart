import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/presentation/cubit/cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingCheckoutListener extends StatelessWidget {
  const BillingCheckoutListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        SafeBlocListener<BillingCubit, BillingState>(
          listenWhen: (prev, curr) => prev.checkout != curr.checkout,
          listener: (context, state) async {
            final session = state.checkout.value;
            if (session == null) return;

            final url = Uri.tryParse(session.url);
            if (url != null) {
              await context.maybePop();
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }

            if (context.mounted) {
              context.read<BillingCubit>().clearCheckout();
            }
          },
        ),

        //handle error
        SafeBlocListener<BillingCubit, BillingState>(
          listenWhen: (prev, curr) => prev.checkout != curr.checkout,
          listener: (context, state) {
            final errorMessage = state.checkout.error?.message as String?;
            if (errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
            //check if user is authenticated
            final isAuthenticated = context
                .read<AuthCubit>()
                .state
                .isAuthenticated;
            if (!isAuthenticated) return;
            context.read<BillingCubit>().getCustomerPortal();
          },
        ),
      ],
      child: child,
    );
  }
}

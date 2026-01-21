import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/billing/presentation/cubit/cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingCheckoutListener extends StatelessWidget {
  const BillingCheckoutListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BillingCubit, BillingState>(
          listenWhen: (prev, curr) => prev.checkout != curr.checkout,
          listener: (context, state) async {
            final session = state.checkout.value;
            if (session == null) return;

            final url = Uri.tryParse(session.url);
            if (url != null) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }

            if (context.mounted) {
              context.read<BillingCubit>().clearCheckout();
            }
          },
        ),

        //handle error
        BlocListener<BillingCubit, BillingState>(
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
      ],
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';
import 'package:lucid_clip/features/account/account.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/feedback/feedback.dart';
import 'package:lucid_clip/features/onboarding/onboarding.dart';

class AppSideEffectsListener extends StatelessWidget {
  const AppSideEffectsListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ...AccessibilitySideEffects.listeners(),
        ...AuthSideEffects.listeners(),
        ...BillingSideEffects.listeners(),
        ...ClipboardSideEffects.listeners(),
        ...EntitlementSideEffects.listeners(),
        ...FeedbackSideEffects.listeners(),
        ...LogoutSideEffects.listeners(),
        ...OnboardingSideEffects.listeners(),
        ...SourceAppPrivacyControlSideEffects.listeners(),
        ...UpgradePromptSideEffects.listeners(
          monthlyProductId: AppConstants.monthlyProductId,
          yearlyProductId: AppConstants.yearlyProductId,
        ),
      ],
      child: child,
    );
  }
}

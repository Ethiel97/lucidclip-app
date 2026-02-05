import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';
import 'package:lucid_clip/features/account/account.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/feedback/feedback.dart';

@RoutePage()
class LucidClipPage extends StatelessWidget {
  const LucidClipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ClipboardCubit>()),
        BlocProvider(create: (_) => getIt<ClipboardDetailCubit>()),
        BlocProvider(create: (_) => getIt<SearchCubit>()),
        BlocProvider(create: (_) => getIt<SidebarCubit>()),
      ],
      child: Scaffold(
        body: AutoTabsRouter(
          routes: [
            const ClipboardRoute(),
            //TODO(Ethiel): Enable snippets when feature is ready
            // const SnippetsRoute(),
            const AccountRoute(),
            SettingsRoute(),
          ],
          builder: (context, child) {
            final (isEntitlementLoaded, isProUser) = context.select(
              (EntitlementCubit cubit) =>
                  (cubit.state.isEntitlementLoaded, cubit.state.isProActive),
            );

            return AuthListener(
              child: FeedbackListener(
                child: EntitlementListener(
                  child: LogoutConfirmationListener(
                    child: AccessibilityPermissionListener(
                      child: UpgradePromptListener(
                        yearlyProductId: AppConstants.yearlyProductId,
                        monthlyProductId: AppConstants.monthlyProductId,
                        child: BillingCheckoutListener(
                          child: ClipboardStorageWarningListener(
                            isEntitlementLoaded: isEntitlementLoaded,
                            isProUser: isProUser,
                            onUpgradeTap: () {
                              context.read<UpgradePromptCubit>().request(
                                ProFeature.unlimitedHistory,
                                source:
                                    ProFeatureRequestSource.historyLimitReached,
                              );
                            },
                            child: SourceAppPrivacyControlListener(
                              child: Row(
                                children: [
                                  const Sidebar(),
                                  const VerticalDivider(
                                    width: 1,
                                    thickness: .15,
                                  ),
                                  Expanded(child: child),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/account/account.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Text(l10n.account.sentenceCase),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => previous.user != current.user,
        builder: (context, authState) => authState.user.maybeWhen(
          success: (user) => ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              // Account Information Section
              SettingsSectionGroupAccordion(
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedUserAccount),
                title: l10n.accountInformation,
                children: [
                  AccountInfoItem(
                    copyable: true,
                    title: l10n.email,
                    value: user?.email ?? l10n.notAvailable,
                    leading: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMail01,
                      size: 20,
                    ),
                  ),
                ],
              ),

              SettingsSectionGroupAccordion(
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedPayment01),
                title: l10n.subscription,
                children: [
                  BlocBuilder<EntitlementCubit, EntitlementState>(
                    buildWhen: (previous, current) =>
                        previous.entitlement != current.entitlement,
                    builder: (context, entitlementState) =>
                        entitlementState.entitlement.maybeWhen(
                          success: (entitlement) {
                            final isPro = entitlement?.isProActive ?? false;
                            final validUntil = entitlement?.validUntil;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AccountInfoItem(
                                  title: l10n.subscriptionType,
                                  value: isPro
                                      ? l10n.proSubscription
                                      : l10n.freeSubscription,
                                  leading: HugeIcon(
                                    icon: isPro
                                        ? HugeIcons.strokeRoundedMedal01
                                        : HugeIcons.strokeRoundedUserAccount,
                                    size: 20,
                                  ),
                                ),
                                if (isPro && validUntil != null) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  AccountInfoItem(
                                    copyable: true,
                                    title: l10n.validUntil,
                                    value: DateFormat.yMMMd().format(
                                      validUntil,
                                    ),
                                    leading: const HugeIcon(
                                      icon: HugeIcons.strokeRoundedCalendar03,
                                      size: 20,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.lg),

                                // Actions
                                if (!isPro)
                                  const _UpgradeButton()
                                else
                                  const _ManageSubscriptionButton(),
                              ],
                            );
                          },
                          orElse: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AccountInfoItem(
                                title: l10n.subscriptionType,
                                value: l10n.freeSubscription,
                                leading: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserAccount,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const _UpgradeButton(),
                            ],
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
          orElse: SizedBox.shrink,
        ),
      ),
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: () {
        context.read<UpgradePromptCubit>().request(
          ProFeature.unlimitedHistory,
          source: ProFeatureRequestSource.accountPage,
        );
      },
      icon: const HugeIcon(icon: HugeIcons.strokeRoundedMedal01, size: 20),
      label: Text(l10n.upgradeToPro),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ManageSubscriptionButton extends StatelessWidget {
  const _ManageSubscriptionButton();

  Future<void> _openCustomerPortal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.failedToOpenUrl),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<BillingCubit, BillingState>(
      buildWhen: (previous, current) =>
          previous.customerPortal != current.customerPortal,
      builder: (context, billingState) => billingState.customerPortal.maybeWhen(
        success: (portal) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: OutlinedButton.icon(
            onPressed: () => _openCustomerPortal(context, portal!.url),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedManager,
              size: 20,
            ),
            label: Text(l10n.manageSubscription.sentenceCase),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              side: BorderSide(color: colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        loading: (_) => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: CircularProgressIndicator(),
          ),
        ),
        orElse: () {
          // Initial state - try to load
          return OutlinedButton.icon(
            onPressed: () {
              context.read<BillingCubit>().getCustomerPortal();
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
            ),
            label: Text(l10n.retry.sentenceCase),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              side: BorderSide(color: colorScheme.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}

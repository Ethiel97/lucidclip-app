import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/account/presentation/widgets/account_info_item.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';
import 'package:lucid_clip/features/billing/billing.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Text(l10n.account.sentenceCase),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return authState.user.maybeWhen(
            success: (user) {
              if (user == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedUserAccount,
                        size: 128,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.signInToViewAccount,
                        style: textTheme.headlineMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Account Information Section
                  _SectionHeader(title: l10n.accountInformation),
                  const SizedBox(height: AppSpacing.md),
                  AccountInfoItem(
                    title: l10n.email,
                    value: user.email ?? l10n.notAvailable,
                    leading: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMail01,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xlg),

                  // Subscription Section
                  _SectionHeader(title: l10n.subscription),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<EntitlementCubit, EntitlementState>(
                    builder: (context, entitlementState) {
                      return entitlementState.entitlement.maybeWhen(
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
                                  title: l10n.validUntil,
                                  value: DateFormat.yMMMd().format(validUntil),
                                  leading: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedCalendar03,
                                    size: 20,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.lg),

                              // Actions
                              if (!isPro)
                                _UpgradeButton()
                              else
                                _ManageSubscriptionButton(),
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
                            _UpgradeButton(),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
            orElse: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedUserAccount,
                    size: 128,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.signInToViewAccount,
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title.sentenceCase,
      style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }
}

class _UpgradeButton extends StatelessWidget {
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
      icon: const HugeIcon(
        icon: HugeIcons.strokeRoundedMedal01,
        size: 20,
      ),
      label: Text(l10n.upgradeToPro),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ManageSubscriptionButton extends StatelessWidget {
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
      builder: (context, billingState) {
        return billingState.customerPortal.maybeWhen(
          success: (portal) {
            if (portal == null || portal.isExpired) {
              // Refresh portal if expired
              context.read<BillingCubit>().getCustomerPortal();
              return const SizedBox.shrink();
            }

            return OutlinedButton.icon(
              onPressed: () => _openCustomerPortal(context, portal.url),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedSettings03,
                size: 20,
              ),
              label: Text(l10n.manageSubscription),
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
            );
          },
          loading: (_) => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => OutlinedButton.icon(
            onPressed: () {
              context.read<BillingCubit>().getCustomerPortal();
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
            ),
            label: Text(l10n.retry),
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
          ),
          orElse: () {
            // Initial state - try to load
            context.read<BillingCubit>().getCustomerPortal();
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

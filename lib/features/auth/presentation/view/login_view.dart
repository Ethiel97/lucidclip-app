import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/app_spacing.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:toastification/toastification.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous.user != current.user,
          listener: (context, state) {
            if (state.hasError) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.fillColored,
                title: Text(l10n.authenticationError.sentenceCase),
                description: Text(
                  state.errorMessage ?? l10n.errorOccurred.sentenceCase,
                ),
                autoCloseDuration: const Duration(seconds: 5),
              );
            } else if (state.isAuthenticated) {
              context.router.root.back();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            // Base background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surface, // matches your dark style
                ),
              ),
            ),

            // Subtle glow (very soft, premium)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.6, -0.8),
                      radius: 1.2,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.75],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xlg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _LoginCard(
                    title: l10n.appName,
                    subtitle: l10n.appTagLine,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {
                  context.router.back();
                },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  size: AppSpacing.xlg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.title,
    required this.subtitle,
    required this.textTheme,
    required this.colorScheme,
  });

  final String title;
  final String subtitle;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: colorScheme.outline.withValues(alpha: 0.8),
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxlg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxlg),

            const _GitHubSignInButton(),

            const SizedBox(height: AppSpacing.lg),

            // Trust / privacy note (soft)
            Text(
              'Local-first by default. Sign in only when you want to sync.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GitHubSignInButton extends StatelessWidget {
  const _GitHubSignInButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, c) => p.isLoading != c.isLoading,
      builder: (context, state) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () => context.read<AuthCubit>().signInWithGitHub(),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.92),
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.primary.withValues(
              alpha: 0.35,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                const HugeIcon(icon: HugeIcons.strokeRoundedGithub),
              const SizedBox(width: 10),
              Text(
                state.isLoading
                    ? l10n.signingIn.sentenceCase
                    : l10n.signInWith(l10n.github),
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

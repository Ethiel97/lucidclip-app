import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/feedback/feedback_module.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

/// A widget that listens for logout requests and shows a confirmation dialog.
/// It also handles the logout result and navigation.
class LogoutConfirmationListener extends StatelessWidget {
  const LogoutConfirmationListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        SafeBlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.isLogoutRequested != current.isLogoutRequested,
          listener: (outerContext, state) async {
            if (state.isLogoutRequested) {
              final result = await showDialog<bool>(
                context: outerContext,
                builder: (context) => AlertDialog(
                  title: Text(l10n.confirmLogout.sentenceCase),
                  content: Text(l10n.signOutConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        outerContext.router.maybePop(false);
                      },
                      child: Text(l10n.cancel.sentenceCase),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        outerContext.router.maybePop(true);
                      },
                      child: Text(l10n.signOut.sentenceCase),
                    ),
                  ],
                ),
              );

              if (result ?? false) {
                // proceed with logout
                await Future<void>.delayed(const Duration(milliseconds: 500));
                if (outerContext.mounted) {
                  await outerContext.read<AuthCubit>().signOut();
                }
              } else {
                // cancel logout
                if (outerContext.mounted) {
                  unawaited(outerContext.read<AuthCubit>().cancelLogout());
                }
              }
            }
          },
        ),
        SafeBlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.logoutResult != current.logoutResult,
          listener: (context, state) {
            if (state.logoutResult.isSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.router.replaceAll([const LucidClipRoute()]);
                }
              });
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.isAuthenticated && !current.isAuthenticated,
          listener: (context, state) {
            // Clear state when user becomes unauthenticated
            context.read<AuthCubit>().clearState();

            getIt<FeedbackService>().clearMetadata();
          },
        ),
      ],
      child: child,
    );
  }
}

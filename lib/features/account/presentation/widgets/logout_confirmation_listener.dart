import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class LogoutSideEffects {
  static List<SafeBlocListener<AuthCubit, AuthState>> listeners() => [
    SafeBlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.isLogoutRequested != current.isLogoutRequested,
      listener: (context, state) async {
        if (state.isLogoutRequested) {
          final l10n = context.l10n;
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.confirmLogout.sentenceCase),
              content: Text(l10n.signOutConfirmation),
              actions: [
                TextButton(
                  onPressed: () {
                    context.router.maybePop(false);
                  },
                  child: Text(l10n.cancel.sentenceCase),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.router.maybePop(true);
                  },
                  child: Text(l10n.signOut.sentenceCase),
                ),
              ],
            ),
          );

          if (result ?? false) {
            // proceed with logout
            await Future<void>.delayed(const Duration(milliseconds: 500));
            if (context.mounted) {
              await context.read<AuthCubit>().signOut();
            }
          } else {
            // cancel logout
            if (context.mounted) {
              unawaited(context.read<AuthCubit>().cancelLogout());
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
  ];
}

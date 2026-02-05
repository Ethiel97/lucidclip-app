import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/feedback/feedback_module.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        SafeBlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.isAuthenticating != current.isAuthenticating,
          listener: (context, state) {
            if (state.isAuthenticating) {
              getIt<WindowController>().setSafeAlwaysOnTop(alwaysOnTop: false);
              return;
            }

            if (!state.isAuthenticating) {
              getIt<WindowController>().setSafeAlwaysOnTop();
            }
          },
        ),

        SafeBlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.isAuthenticated != current.isAuthenticated,
          listener: (context, state) {
            if (state.isAuthenticated) {
              unawaited(
                getIt<FeedbackService>().setMetadata({
                  'userId': state.user.value?.id,
                  'userEmail': state.user.value?.email,
                }),
              );
            }
          },
        ),
      ],
      child: child ?? const SizedBox.shrink(),
    );
  }
}

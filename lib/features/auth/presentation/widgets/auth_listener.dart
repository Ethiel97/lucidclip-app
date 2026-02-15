import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/feedback/feedback_module.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/auth/auth.dart';

class AuthSideEffects {
  static List<SafeBlocListener<AuthCubit, AuthState>> listeners() => [
    SafeBlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.isAuthenticating != current.isAuthenticating ||
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        final windowController = getIt<WindowController>();
        final feedbackService = getIt<FeedbackService>();

        if (state.isAuthenticating) {
          windowController.setSafeAlwaysOnTop(alwaysOnTop: false);
          return;
        }

        if (state.isAuthenticated && state.user.value != null) {
          unawaited(
            feedbackService.setMetadata({
              'userId': state.user.value?.id,
              'userEmail': state.user.value?.email,
            }),
          );
        }

        if (!state.isAuthenticated) {
          context.read<AuthCubit>().clearState();

          unawaited(getIt<FeedbackService>().clearMetadata());
        }

        windowController.setSafeAlwaysOnTop();
      },
    ),
  ];
}

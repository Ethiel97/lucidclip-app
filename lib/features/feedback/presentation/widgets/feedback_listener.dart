import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/feedback/feedback_module.dart';
import 'package:lucid_clip/core/widgets/safe_bloc_listener.dart';
import 'package:lucid_clip/features/feedback/feedback.dart';

class FeedbackSideEffects {
  static List<SafeBlocListener<FeedbackCubit, FeedbackState>> listeners() => [
    SafeBlocListener<FeedbackCubit, FeedbackState>(
      listenWhen: (previous, current) =>
          previous.showFeedback != current.showFeedback,
      listener: (context, state) async {
        if (state.showFeedback) {
          // Show the feedback UI
          await getIt<FeedbackService>().show(context);
          // Clear the request
          if (context.mounted) {
            context.read<FeedbackCubit>().clearRequest();
          }
        }
      },
    ),
  ];
}

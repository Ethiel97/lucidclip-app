import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'feedback_state.dart';

/// Cubit for managing feedback requests from contexts without BuildContext
/// (e.g., system tray menu items).
///
/// This cubit allows requesting feedback UI to be shown without needing
/// a BuildContext. A BlocListener in the app widget tree will listen for
/// the request and show the feedback UI with the appropriate context.
@lazySingleton
class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(const FeedbackState());

  /// Request that the feedback UI be shown
  void requestFeedback() {
    emit(state.copyWith(showFeedback: true));
  }

  /// Clear the feedback request after it has been handled
  void clearRequest() {
    emit(state.copyWith(showFeedback: false));
  }
}

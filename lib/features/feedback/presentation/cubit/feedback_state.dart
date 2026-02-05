part of 'feedback_cubit.dart';

/// State for feedback requests
class FeedbackState extends Equatable {
  const FeedbackState({this.showFeedback = false});

  /// Whether to show the feedback UI
  final bool showFeedback;

  FeedbackState copyWith({bool? showFeedback}) {
    return FeedbackState(showFeedback: showFeedback ?? this.showFeedback);
  }

  @override
  List<Object?> get props => [showFeedback];
}

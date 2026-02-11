part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.hasSeenToggleWindowShortcutTip,
    required this.hasUsedToggleWindowShortcut,
    required this.toggleWindowShortcutReminderCount,
    required this.showToggleWindowShortcutTipNow,
  });

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      hasSeenToggleWindowShortcutTip:
          (json['hasSeenToggleWindowShortcutTip'] as bool?) ?? false,
      hasUsedToggleWindowShortcut:
          (json['hasUsedToggleWindowShortcut'] as bool?) ?? false,
      toggleWindowShortcutReminderCount:
          (json['toggleWindowShortcutReminderCount'] as int?) ?? 0,
      showToggleWindowShortcutTipNow: false,
    );
  }

  final bool hasSeenToggleWindowShortcutTip;
  final bool hasUsedToggleWindowShortcut;
  final int toggleWindowShortcutReminderCount;

  // UI intent (ephemeral)
  final bool showToggleWindowShortcutTipNow;

  static const initial = OnboardingState(
    hasSeenToggleWindowShortcutTip: false,
    hasUsedToggleWindowShortcut: false,
    toggleWindowShortcutReminderCount: 0,
    showToggleWindowShortcutTipNow: false,
  );

  OnboardingState copyWith({
    bool? hasSeenToggleWindowShortcutTip,
    bool? hasUsedToggleWindowShortcut,
    int? toggleWindowShortcutReminderCount,
    bool? showToggleWindowShortcutTipNow,
  }) {
    return OnboardingState(
      hasSeenToggleWindowShortcutTip:
          hasSeenToggleWindowShortcutTip ?? this.hasSeenToggleWindowShortcutTip,
      hasUsedToggleWindowShortcut:
          hasUsedToggleWindowShortcut ?? this.hasUsedToggleWindowShortcut,
      toggleWindowShortcutReminderCount:
          toggleWindowShortcutReminderCount ??
          this.toggleWindowShortcutReminderCount,
      showToggleWindowShortcutTipNow:
          showToggleWindowShortcutTipNow ?? this.showToggleWindowShortcutTipNow,
    );
  }

  Map<String, dynamic> toJson() => {
    'hasSeenToggleWindowShortcutTip': hasSeenToggleWindowShortcutTip,
    'hasUsedToggleWindowShortcut': hasUsedToggleWindowShortcut,
    'toggleWindowShortcutReminderCount': toggleWindowShortcutReminderCount,
  };

  @override
  List<Object?> get props => [
    hasSeenToggleWindowShortcutTip,
    hasUsedToggleWindowShortcut,
    toggleWindowShortcutReminderCount,
    showToggleWindowShortcutTipNow,
  ];
}

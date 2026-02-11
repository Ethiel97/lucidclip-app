// lib/features/onboarding/presentation/cubit/onboarding_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_state.dart';

const Duration tipAutoCloseDuration = Duration(seconds: 10);

@lazySingleton
class OnboardingCubit extends HydratedCubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.initial);

  Timer? _reminderTimer;

  void boot() {
    if (state.hasUsedToggleWindowShortcut) return;

    // Show once on first launch
    if (!state.hasSeenToggleWindowShortcutTip) {
      emit(state.copyWith(showToggleWindowShortcutTipNow: true));
      return;
    }

    // Optional: schedule a single reminder (lightweight)
    _scheduleReminderIfNeeded();
  }

  void markToggleWindowShortcutTipSeen() {
    emit(
      state.copyWith(
        hasSeenToggleWindowShortcutTip: true,
        showToggleWindowShortcutTipNow: false,
      ),
    );
  }

  void onToggleWindowShortcutUsed() {
    _reminderTimer?.cancel();
    emit(
      state.copyWith(
        hasUsedToggleWindowShortcut: true,
        showToggleWindowShortcutTipNow: false,
      ),
    );
  }

  void _scheduleReminderIfNeeded() {
    if (state.hasUsedToggleWindowShortcut) return;
    if (state.toggleWindowShortcutReminderCount >= 1) return;

    _reminderTimer?.cancel();
    _reminderTimer = Timer(const Duration(minutes: 5), () {
      if (state.hasUsedToggleWindowShortcut) return;
      emit(
        state.copyWith(
          toggleWindowShortcutReminderCount:
              state.toggleWindowShortcutReminderCount + 1,
          showToggleWindowShortcutTipNow: true,
        ),
      );
    });
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    try {
      return OnboardingState.fromJson(json);
    } catch (_) {
      return OnboardingState.initial;
    }
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) => state.toJson();

  @override
  @disposeMethod
  Future<void> close() {
    _reminderTimer?.cancel();
    return super.close();
  }
}

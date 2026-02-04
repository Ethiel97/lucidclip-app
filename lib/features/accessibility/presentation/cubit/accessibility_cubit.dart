import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';

part 'accessibility_state.dart';

@lazySingleton
class AccessibilityCubit extends HydratedCubit<AccessibilityState> {
  AccessibilityCubit({required this.repository})
    : super(const AccessibilityState()) {
    listenToPermissionChanges();
  }

  StreamSubscription<bool>? _permissionStatusSubscription;

  final AccessibilityRepository repository;

  void listenToPermissionChanges() {
    _permissionStatusSubscription?.cancel();
    _permissionStatusSubscription = repository.permissionStatusStream.listen(
      (hasPermission) {
        emit(state.copyWith(hasPermission: hasPermission));
      },
      onError: (Object error) {
        log(
          'Permission status stream error: $error',
          name: 'AccessibilityCubit.listenToPermissionChanges',
        );
        emit(state.copyWith(hasPermission: false));
      },
    );
  }

  /// Check if accessibility permission is granted
  Future<void> checkPermission() async {
    emit(state.copyWith(isChecking: true));

    try {
      final hasPermission = await repository.checkPermission();
      emit(state.copyWith(hasPermission: hasPermission, isChecking: false));
    } catch (e, stack) {
      log(
        'Error checking accessibility permission: $e',
        name: 'AccessibilityCubit.checkPermission',
        error: e,
        stackTrace: stack,
      );
      emit(state.copyWith(hasPermission: false, isChecking: false));
    }
  }

  /// Request accessibility permission and show the custom dialog
  Future<void> requestPermission() async {
    // Track permission requested event
    await Analytics.track(AnalyticsEvent.permissionAccessibilityRequested);
    emit(state.copyWith(showPermissionDialog: true));
  }

  /// User granted permission from the custom dialog
  Future<void> grantPermission() async {
    emit(state.copyWith(showPermissionDialog: false));
    try {
      await repository.requestPermission();
      await checkPermission();
      
      // Track permission granted if successful
      if (state.hasPermission) {
        await Analytics.track(AnalyticsEvent.permissionAccessibilityGranted);
      }
    } catch (e, stack) {
      log(
        'Error granting accessibility permission: $e',
        name: 'AccessibilityCubit.grantPermission',
        error: e,
        stackTrace: stack,
      );
      emit(state.copyWith(hasPermission: false));
      
      // Track permission denied on error
      await Analytics.track(AnalyticsEvent.permissionAccessibilityDenied);
    }
  }

  /// User cancelled the permission dialog
  Future<void> cancelPermissionRequest() async {
    emit(state.copyWith(showPermissionDialog: false));
    
    // Track permission denied when user cancels
    await Analytics.track(AnalyticsEvent.permissionAccessibilityDenied);
  }

  @override
  AccessibilityState? fromJson(Map<String, dynamic> json) {
    try {
      return AccessibilityState.fromJson(json);
    } catch (e, stack) {
      log(
        'Error deserializing AccessibilityState: $e',
        name: 'AccessibilityCubit.fromJson',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AccessibilityState state) {
    try {
      return state.toJson();
    } catch (e, stack) {
      log(
        'Error serializing AccessibilityState: $e',
        name: 'AccessibilityCubit.toJson',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  @disposeMethod
  @override
  Future<void> close() {
    _permissionStatusSubscription?.cancel();
    return super.close();
  }
}

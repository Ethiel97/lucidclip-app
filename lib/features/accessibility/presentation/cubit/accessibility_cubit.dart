import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/accessibility/domain/repositories/accessibility_repository.dart';

part 'accessibility_state.dart';

@lazySingleton
class AccessibilityCubit extends HydratedCubit<AccessibilityState> {
  AccessibilityCubit({
    required this.repository,
  }) : super(const AccessibilityState()) {
    checkPermission();
  }

  final AccessibilityRepository repository;

  /// Check if accessibility permission is granted
  Future<void> checkPermission() async {
    emit(state.copyWith(isChecking: true));
    
    try {
      final hasPermission = await repository.checkPermission();
      emit(state.copyWith(
        hasPermission: hasPermission,
        isChecking: false,
      ));
    } catch (e, stack) {
      log(
        'Error checking accessibility permission: $e',
        name: 'AccessibilityCubit.checkPermission',
        error: e,
        stackTrace: stack,
      );
      emit(state.copyWith(
        hasPermission: false,
        isChecking: false,
      ));
    }
  }

  /// Request accessibility permission and show the custom dialog
  Future<void> requestPermission() async {
    emit(state.copyWith(showPermissionDialog: true));
  }

  /// User granted permission from the custom dialog
  Future<void> grantPermission() async {
    emit(state.copyWith(showPermissionDialog: false));
    
    try {
      final granted = await repository.requestPermission();
      
      // Re-check after a short delay to get the updated status
      await Future.delayed(const Duration(milliseconds: 500));
      await checkPermission();
      
      if (!granted) {
        log(
          'Permission not granted',
          name: 'AccessibilityCubit.grantPermission',
        );
      }
    } catch (e, stack) {
      log(
        'Error granting accessibility permission: $e',
        name: 'AccessibilityCubit.grantPermission',
        error: e,
        stackTrace: stack,
      );
      emit(state.copyWith(hasPermission: false));
    }
  }

  /// User cancelled the permission dialog
  void cancelPermissionRequest() {
    emit(state.copyWith(showPermissionDialog: false));
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
}

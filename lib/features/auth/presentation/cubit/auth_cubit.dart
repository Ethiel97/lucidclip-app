import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/data/data.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';

part 'auth_state.dart';

/// Cubit for managing authentication state
@lazySingleton
class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _initializeAuthState();
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  /// Initialize authentication state by checking current user
  /// and listening to auth state changes
  void _initializeAuthState() {
    // Listen to auth state changes

    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      _onAuthStateChanged,
      onError: (Object error) {
        log('Auth state change error: $error');
        emit(
          state.copyWith(
            user: state.user.toError(
              ErrorDetails(message: 'Authentication state error: $error'),
            ),
          ),
        );
      },
    );

    // Check current authentication status
    checkAuthStatus();
  }

  /// Handle auth state changes from the stream
  void _onAuthStateChanged(User? user) async {
    if (user != null && user.isNotEmpty) {
      emit(state.copyWith(user: state.user.toSuccess(user)));
      // Set user context for observability
      await Observability.setUser(user.id);
      await Observability.breadcrumb(
        'User authenticated',
        category: 'auth',
        level: ObservabilityLevel.info,
      );
    } else {
      emit(state.copyWith(user: const ValueWrapper<User?>()));
      // Clear user context on signout
      await Observability.clearUser();
      await Observability.breadcrumb(
        'User signed out',
        category: 'auth',
        level: ObservabilityLevel.info,
      );
    }
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null && !user.isAnonymous) {
        emit(state.copyWith(user: state.user.toSuccess(user)));
      } else {
        emit(state.copyWith(user: const ValueWrapper<User?>()));
      }
    } catch (e) {
      await Observability.captureException(
        e,
        hint: {'operation': 'check_auth_status'},
      );
      emit(
        state.copyWith(
          user: state.user.toError(
            const ErrorDetails(
              message: 'Failed to check authentication status',
            ),
          ),
        ),
      );
    }
  }

  /// Sign in with GitHub OAuth
  Future<void> signInWithGitHub() async {
    emit(state.copyWith(user: state.user.toLoading()));

    try {
      final user = await _authRepository.signInWithGitHub();

      if (user != null && !user.isAnonymous) {
        emit(state.copyWith(user: state.user.toSuccess(user)));
        await Observability.breadcrumb(
          'GitHub sign-in successful',
          category: 'auth',
          level: ObservabilityLevel.info,
        );
      } else {
        emit(
          state.copyWith(
            user: state.user.toError(
              const ErrorDetails(
                message: 'GitHub sign in was cancelled or failed',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      await Observability.captureException(
        e,
        hint: {'operation': 'github_signin'},
      );
      await Observability.breadcrumb(
        'GitHub sign-in failed',
        category: 'auth',
        level: ObservabilityLevel.error,
      );
      emit(
        state.copyWith(
          user: state.user.toError(
            ErrorDetails(message: 'Failed to sign in with GitHub: $e'),
          ),
        ),
      );
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      emit(state.copyWith(logoutResult: state.logoutResult.toLoading()));

      await _authRepository.signOut();
      emit(state.copyWith(logoutResult: state.logoutResult.toSuccess(null)));
    } catch (e) {
      await Observability.captureException(
        e,
        hint: {'operation': 'signout'},
      );
      emit(
        state.copyWith(
          logoutResult: state.logoutResult.toError(
            ErrorDetails(message: 'Failed to sign out: $e'),
          ),
        ),
      );
    }
  }

  void clearState() {
    emit(const AuthState());
  }

  Future<void> requestLogout() async {
    emit(state.copyWith(logoutRequest: true));
  }

  Future<void> cancelLogout() async {
    emit(state.copyWith(logoutRequest: false));
  }

  @disposeMethod
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthState.fromJson(json);
    } catch (e) {
      log('Error deserializing auth state: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try {
      return state.toJson();
    } catch (e) {
      log('Error serializing auth state: $e');
      return null;
    }
  }
}

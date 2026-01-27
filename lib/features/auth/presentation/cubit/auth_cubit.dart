import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
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
  void _onAuthStateChanged(User? user) {
    if (user != null && user.isNotEmpty) {
      emit(state.copyWith(user: state.user.toSuccess(user)));
      log('User authenticated: ${user.email}');
    } else {
      emit(state.copyWith(user: const ValueWrapper<User?>()));
      log('User unauthenticated', name: 'AuthCubit');
    }
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();

      if (user != null && user.isNotEmpty) {
        emit(state.copyWith(user: state.user.toSuccess(user)));
      } else {
        emit(state.copyWith(user: const ValueWrapper<User?>()));
      }
    } catch (e) {
      log('Error checking auth status: $e');
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

      if (user != null && user.isNotEmpty) {
        emit(state.copyWith(user: state.user.toSuccess(user)));
        log('Successfully signed in with GitHub: ${user.email}');
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
      log('Error during GitHub sign in: $e');
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
      log('Successfully signed out');
    } catch (e) {
      log('Error during sign out: $e');
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

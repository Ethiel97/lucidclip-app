import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/constants/app_constants.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/storage/storage.dart';
import 'package:lucid_clip/features/auth/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

/// Data source for Supabase authentication operations
@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource implements AuthDataSource {
  SupabaseAuthDataSource({
    required SupabaseClient supabaseClient,
    required SecureStorageService secureStorage,
  }) : _supabase = supabaseClient,
       _secureStorage = secureStorage;

  final SupabaseClient _supabase;
  final SecureStorageService _secureStorage;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  Future<UserModel?> signInWithGitHub() async {
    try {
      final redirectTo = _getRedirectUrl();
      log('Starting GitHub OAuth with redirect: $redirectTo');

      final completer = Completer<UserModel?>();

      // Listen for the auth state change just once.
      _authSubscription = _supabase.auth.onAuthStateChange.listen(
        (data) {
          final session = data.session;
          if (session != null && !completer.isCompleted) {
            log('Auth state changed, user signed in: ${session.user.email}');
            final userModel = UserModel.fromSupabaseUser(session.user);
            completer.complete(userModel);
          }
        },
        onError: (Object error) {
          if (!completer.isCompleted) {
            completer.completeError(
              AuthenticationException('Auth state change error: $error'),
            );
          }
        },
      );

      // Launch OAuth flow. Supabase will handle the deep link internally.
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: redirectTo,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!response) {
        log('GitHub OAuth failed or was cancelled by user.');
        return null;
      }

      log('OAuth flow initiated, waiting for auth state change...');

      // Wait for the onAuthStateChange listener to complete.
      final userModel = await completer.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () {
          log('Sign in timed out waiting for auth state change.');
          return null;
        },
      );

      if (userModel == null) {
        log('No user model received after auth flow.');
        return null;
      }

      final accessToken = _supabase.auth.currentSession?.accessToken;
      if (accessToken != null) {
        await _secureStorage.write(
          key: SecureStorageConstants.authToken,
          value: accessToken,
        );
      }

      await _storeUserData(_supabase.auth.currentUser);

      return userModel;
    } on AuthException catch (e) {
      Observability.captureException(
        e,
        hint: {'operation': 'github_oauth'},
      ).unawaited();
      throw AuthenticationException(
        'Failed to sign in with GitHub: ${e.message}',
      );
    } catch (e, stack) {
      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'github_oauth'},
      ).unawaited();
      throw AuthenticationException('An unexpected error occurred: $e');
    } finally {
      await _authSubscription?.cancel();
      _authSubscription = null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearLocalData();
    } catch (e, stack) {
      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'signout'},
      ).unawaited();
      throw AuthenticationException('An error occurred during sign out: $e');
    }
  }

  Future<void> _clearLocalData() async {
    try {
      await _secureStorage.delete(key: SecureStorageConstants.authToken);
      await _secureStorage.delete(key: SecureStorageConstants.userId);
      await _secureStorage.delete(key: SecureStorageConstants.userEmail);
      await _secureStorage.delete(key: SecureStorageConstants.user);
      log('Local user data cleared.');
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      return UserModel.fromSupabaseUser(currentUser);
    } catch (e, stackTrace) {
      Observability.captureException(
        e,
        stackTrace: stackTrace,
        hint: {'operation': 'getCurrentUser'},
      ).unawaited();
      log('Error getting current user: $e');
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange
        .map((event) {
          final user = event.session?.user;
          if (user == null) {
            return null;
          }
          return UserModel.fromSupabaseUser(user);
        })
        .distinct((previous, next) => previous?.id == next?.id);
  }

  /// Store user data in secure storage
  Future<void> _storeUserData(User? user) async {
    try {
      if (user == null) {
        log('No user data to store in secure storage');
        return;
      }
      await _secureStorage.write(
        key: SecureStorageConstants.userId,
        value: user.id,
      );

      if (user.email != null) {
        await _secureStorage.write(
          key: SecureStorageConstants.userEmail,
          value: user.email!,
        );
      }

      log('User data stored in secure storage');
    } catch (e) {
      log('Error storing user data: $e');
    }
  }

  /// Get the redirect URL for OAuth callback
  /// Platform-specific deep link schemes
  String _getRedirectUrl() {
    // For macOS and Windows desktop apps, we use a custom scheme
    // This should match the URL scheme configured in Info.plist (macOS)
    // and main.cpp (Windows)
    return '${AppConstants.oAuthRedirectScheme}://auth-callback';
  }
}

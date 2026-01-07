import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
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

  @override
  Future<UserModel?> signInWithGitHub() async {
    try {
      // Use the platform-specific deep link scheme
      final redirectTo = _getRedirectUrl();

      log('Starting GitHub OAuth with redirect: $redirectTo');

      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: redirectTo,
      );

      if (!response) {
        log('GitHub OAuth failed or was cancelled');
        return null;
      }

      // Wait for the auth state to update
      await Future<void>.delayed(const Duration(seconds: 2));

      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        log('No user found after OAuth completion');
        return null;
      }

      // Store user information in secure storage
      await _storeUserData(currentUser);

      return UserModel.fromSupabaseUser(currentUser);
    } on AuthException catch (e) {
      log('Auth error during GitHub sign in: ${e.message}');
      throw AuthenticationException(
        'Failed to sign in with GitHub: ${e.message}',
      );
    } catch (e, stack) {
      log('Unexpected error during GitHub sign in: $e', stackTrace: stack);
      throw AuthenticationException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();

      // Clear stored user data
      await _secureStorage.delete(key: SecureStorageConstants.userId);
      await _secureStorage.delete(key: SecureStorageConstants.userEmail);
      await _secureStorage.delete(key: SecureStorageConstants.user);

      log('User signed out successfully');
    } on AuthException catch (e) {
      log('Auth error during sign out: ${e.message}');
      throw AuthenticationException('Failed to sign out: ${e.message}');
    } catch (e) {
      log('Unexpected error during sign out: $e');
      throw AuthenticationException('An unexpected error occurred: $e');
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
    } catch (e) {
      log('Error getting current user: $e');
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) {
        return null;
      }
      return UserModel.fromSupabaseUser(user);
    });
  }

  /// Store user data in secure storage
  Future<void> _storeUserData(User user) async {
    try {
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
    return 'lucidclip://auth-callback';
  }
}

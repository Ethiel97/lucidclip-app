import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/storage/storage.dart';
import 'package:lucid_clip/features/auth/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

/// Data source for Supabase authentication operations
@LazySingleton(as: AuthDataSource)
class SupabaseAuthDataSource implements AuthDataSource {
  SupabaseAuthDataSource({
    required SupabaseClient supabaseClient,
    required SecureStorageService secureStorage,
    required DeepLinkService deepLinkService,
  }) : _supabase = supabaseClient,
       _secureStorage = secureStorage,
       _deepLinkService = deepLinkService;

  final SupabaseClient _supabase;
  final SecureStorageService _secureStorage;
  final DeepLinkService _deepLinkService;

  @override
  Future<UserModel?> signInWithGitHub() async {
    try {
      final redirectTo = _getRedirectUrl();

      log('Starting GitHub OAuth with redirect: $redirectTo');

      // Launch OAuth flow
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: redirectTo,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!response) {
        log('GitHub OAuth failed or was cancelled');
        return null;
      }

      log('OAuth flow initiated, waiting for deep link callback...');

      final deepLinkUri = await _deepLinkService.waitForDeepLink(
        timeout: const Duration(minutes: 3),
        filter: (uri) {
          // Filter for our auth callback scheme
          return uri.scheme == 'lucidclip';
        },
      );

      if (deepLinkUri == null) {
        log('Deep link callback timeout or cancelled');
        return null;
      }

      log('Deep link received: $deepLinkUri');
      // Extract the session from the deep link URI
      // Supabase sends the session info as query parameters or fragment

      await _handleAuthCallback(deepLinkUri);

      // Get the current user after session is established
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        log('No user found after OAuth completion');
        return null;
      }

      final accessToken = _supabase.auth.currentSession?.accessToken;

      if (accessToken != null) {
        await _secureStorage.write(
          key: SecureStorageConstants.authToken,
          value: accessToken,
        );
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

  /// Handle the OAuth callback from the deep link
  Future<void> _handleAuthCallback(Uri uri) async {
    try {
      // The URI will contain either query parameters or a fragment
      // with the access_token and other session data
      final uriString = uri.toString();

      log('Processing auth callback URI: $uriString');

      // Supabase Flutter SDK can handle the callback URL
      await _supabase.auth.getSessionFromUrl(uri);

      log('Session established from callback');
    } catch (e, stack) {
      log('Error handling auth callback: $e', stackTrace: stack);
      throw AuthenticationException('Failed to process auth callback: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearLocalData();
    } catch (e) {
      log('Error during sign out: $e');
      throw AuthenticationException('An error occurred during sign out: $e');
    }
  }

  Future<void> _clearLocalData() async {
    await _secureStorage.delete(key: SecureStorageConstants.authToken);
    await _secureStorage.delete(key: SecureStorageConstants.userId);
    await _secureStorage.delete(key: SecureStorageConstants.userEmail);
    await _secureStorage.delete(key: SecureStorageConstants.user);
    log('Local user data cleared.');
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

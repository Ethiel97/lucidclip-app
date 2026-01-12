import 'package:lucid_clip/features/auth/domain/entities/entities.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in with GitHub OAuth
  /// Returns the authenticated user on success, null on failure
  Future<User?> signInWithGitHub();

  /// Sign out the current user
  Future<void> signOut();

  /// Get the currently authenticated user
  /// Returns null if no user is authenticated
  Future<User?> getCurrentUser();

  /// Stream of authentication state changes
  /// Emits the current user when authenticated, null when not
  Stream<User?> get authStateChanges;

  Future<String?> get currentUserId;
}

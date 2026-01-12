import 'package:lucid_clip/features/auth/data/models/models.dart';

/// Interface for authentication data sources
abstract class AuthDataSource {
  /// Sign in with GitHub OAuth
  Future<UserModel?> signInWithGitHub();

  /// Sign out the current user
  Future<void> signOut();

  /// Get the currently authenticated user
  Future<UserModel?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges;
}

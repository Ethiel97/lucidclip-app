import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.phone,
    this.userMetadata,
    this.createdAt,
    this.lastSignInAt,
  });

  /// User ID from Supabase Auth
  final String id;

  /// User's email address
  final String? email;

  /// User's display name
  final String? displayName;

  /// User's phone number
  final String? phone;

  /// Additional user metadata from the auth provider
  final Map<String, dynamic>? userMetadata;

  /// When the user account was created
  final DateTime? createdAt;

  /// When the user last signed in
  final DateTime? lastSignInAt;

  /// Create an empty user
  factory User.empty() {
    return const User(
      id: '',
      email: null,
    );
  }

  /// Check if user is empty
  bool get isEmpty => id.isEmpty;

  /// Check if user is not empty
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        phone,
        userMetadata,
        createdAt,
        lastSignInAt,
      ];
}

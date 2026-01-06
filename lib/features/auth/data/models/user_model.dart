import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';

part 'user_model.g.dart';

/// User model for JSON serialization
@JsonSerializable(explicitToJson: true)
class UserModel extends Equatable {
  const UserModel({
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
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// User's phone number
  final String? phone;

  /// Additional user metadata from the auth provider
  @JsonKey(name: 'user_metadata')
  final Map<String, dynamic>? userMetadata;

  /// When the user account was created
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// When the user last signed in
  @JsonKey(name: 'last_sign_in_at')
  final DateTime? lastSignInAt;

  /// Create a UserModel from a Supabase Auth User
  factory UserModel.fromSupabaseUser(
    dynamic supabaseUser,
  ) {
    return UserModel(
      id: supabaseUser.id as String,
      email: supabaseUser.email as String?,
      displayName: supabaseUser.userMetadata?['full_name'] as String? ??
          supabaseUser.userMetadata?['name'] as String?,
      phone: supabaseUser.phone as String?,
      userMetadata: supabaseUser.userMetadata as Map<String, dynamic>?,
      createdAt: supabaseUser.createdAt != null
          ? DateTime.parse(supabaseUser.createdAt as String)
          : null,
      lastSignInAt: supabaseUser.lastSignInAt != null
          ? DateTime.parse(supabaseUser.lastSignInAt as String)
          : null,
    );
  }

  /// Create a UserModel from a domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      phone: user.phone,
      userMetadata: user.userMetadata,
      createdAt: user.createdAt,
      lastSignInAt: user.lastSignInAt,
    );
  }

  /// Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      phone: phone,
      userMetadata: userMetadata,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }

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

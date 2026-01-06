import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';

part 'user_model.g.dart';

/// User model for JSON serialization
@JsonSerializable(explicitToJson: true)
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.userMetadata,
    super.createdAt,
  });

  /// Create a UserModel from a Supabase Auth User
  factory UserModel.fromSupabaseUser(
    dynamic supabaseUser,
  ) {
    return UserModel(
      id: supabaseUser.id as String,
      email: supabaseUser.email as String?,
      userMetadata: supabaseUser.userMetadata as Map<String, dynamic>?,
      createdAt: supabaseUser.createdAt != null
          ? DateTime.parse(supabaseUser.createdAt as String)
          : null,
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
      userMetadata: userMetadata,
      createdAt: createdAt,
    );
  }
}

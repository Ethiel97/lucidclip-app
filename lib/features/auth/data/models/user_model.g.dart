// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String?,
  displayName: json['display_name'] as String?,
  phone: json['phone'] as String?,
  userMetadata: json['user_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  lastSignInAt: json['last_sign_in_at'] == null
      ? null
      : DateTime.parse(json['last_sign_in_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'phone': instance.phone,
  'user_metadata': instance.userMetadata,
  'created_at': instance.createdAt?.toIso8601String(),
  'last_sign_in_at': instance.lastSignInAt?.toIso8601String(),
};

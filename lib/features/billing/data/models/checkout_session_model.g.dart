// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutSessionModel _$CheckoutSessionModelFromJson(
  Map<String, dynamic> json,
) => CheckoutSessionModel(
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  id: json['checkoutId'] as String,
  url: json['checkoutUrl'] as String,
);

Map<String, dynamic> _$CheckoutSessionModelToJson(
  CheckoutSessionModel instance,
) => <String, dynamic>{
  'expiresAt': instance.expiresAt.toIso8601String(),
  'checkoutId': instance.id,
  'checkoutUrl': instance.url,
};

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/billing/domain/domain.dart';

// TODO(Ethiel): Fetch customer portal to manage subscriptions

part 'checkout_session_model.g.dart';

@JsonSerializable()
class CheckoutSessionModel extends Equatable {
  const CheckoutSessionModel({
    required this.expiresAt,
    required this.id,
    required this.url,
  });

  factory CheckoutSessionModel.fromEntity(CheckoutSession checkoutSession) {
    return CheckoutSessionModel(
      expiresAt: checkoutSession.expiresAt,
      id: checkoutSession.id,
      url: checkoutSession.url,
    );
  }

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionModelFromJson(json);

  @JsonKey(name: 'expiresAt')
  final DateTime expiresAt;

  @JsonKey(name: 'checkoutId')
  final String id;

  @JsonKey(name: 'checkoutUrl')
  final String url;

  Map<String, dynamic> toJson() => _$CheckoutSessionModelToJson(this);

  CheckoutSession toEntity() {
    return CheckoutSession(expiresAt: expiresAt, id: id, url: url);
  }

  @override
  List<Object?> get props => [expiresAt, id, url];
}

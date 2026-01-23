import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/billing/domain/domain.dart';

part 'customer_portal_model.g.dart';

@JsonSerializable()
class CustomerPortalModel extends Equatable {
  const CustomerPortalModel({required this.expiresAt, required this.url});

  factory CustomerPortalModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerPortalModelFromJson(json);

  factory CustomerPortalModel.fromEntity(CustomerPortal customerPortal) {
    return CustomerPortalModel(
      expiresAt: customerPortal.expiresAt,
      url: customerPortal.url,
    );
  }

  final String url;

  final DateTime expiresAt;

  Map<String, dynamic> toJson() => _$CustomerPortalModelToJson(this);

  CustomerPortal toEntity() {
    return CustomerPortal(expiresAt: expiresAt, url: url);
  }

  @override
  List<Object?> get props => [expiresAt, url];
}

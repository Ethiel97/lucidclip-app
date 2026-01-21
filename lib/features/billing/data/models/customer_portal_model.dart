import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/billing/domain/domain.dart';

part 'customer_portal_model.g.dart';

@JsonSerializable()
class CustomerPortalModel extends Equatable {
  const CustomerPortalModel({required this.url});

  factory CustomerPortalModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerPortalModelFromJson(json);

  factory CustomerPortalModel.fromEntity(CustomerPortal customerPortal) {
    return CustomerPortalModel(url: customerPortal.url);
  }

  @JsonKey(name: 'url')
  final String url;

  Map<String, dynamic> toJson() => _$CustomerPortalModelToJson(this);

  CustomerPortal toEntity() {
    return CustomerPortal(url: url);
  }

  @override
  List<Object?> get props => [url];
}

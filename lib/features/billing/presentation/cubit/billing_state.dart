part of 'billing_cubit.dart';

class BillingState extends Equatable {
  const BillingState({
    this.checkout = const ValueWrapper<CheckoutSession?>(),
    this.customerPortal = const ValueWrapper<CustomerPortal?>(),
  });

  factory BillingState.fromJson(Map<String, dynamic> json) {
    final checkoutJson = json['checkout'] as Map<String, dynamic>?;
    final portalJson = json['customerPortal'] as Map<String, dynamic>?;

    return BillingState(
      checkout: checkoutJson != null
          ? CheckoutSessionModel.fromJson(checkoutJson).toEntity().toSuccess()
          : const ValueWrapper<CheckoutSession?>(),
      customerPortal: portalJson != null
          ? CustomerPortalModel.fromJson(portalJson).toEntity().toSuccess()
          : const ValueWrapper<CustomerPortal?>(),
    );
  }

  final ValueWrapper<CheckoutSession?> checkout;

  final ValueWrapper<CustomerPortal?> customerPortal;

  BillingState copyWith({
    ValueWrapper<CheckoutSession?>? checkout,
    ValueWrapper<CustomerPortal?>? customerPortal,
  }) {
    return BillingState(
      checkout: checkout ?? this.checkout,
      customerPortal: customerPortal ?? this.customerPortal,
    );
  }

  bool get isLoading => checkout.isLoading;

  String get portalUrl =>
      customerPortal.isSuccess && customerPortal.value != null
      ? customerPortal.value!.url
      : '';

  bool get needsPortalRenew =>
      customerPortal.value != null && (customerPortal.value!.isExpired);

  Map<String, dynamic> toJson() {
    return {
      'checkout': checkout.value != null
          ? CheckoutSessionModel.fromEntity(checkout.value!).toJson()
          : null,
      'customerPortal': customerPortal.value != null
          ? CustomerPortalModel.fromEntity(customerPortal.value!).toJson()
          : null,
    };
  }

  @override
  List<Object?> get props => [checkout, customerPortal];
}

part of 'billing_cubit.dart';

class BillingState extends Equatable {
  const BillingState({
    this.checkout = const ValueWrapper<CheckoutSession?>(),
    this.customerPortal = const ValueWrapper<CustomerPortal?>(),
  });

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

  bool get shouldRenewPortal =>
      customerPortal.isSuccess &&
      customerPortal.value != null &&
      customerPortal.value!.isExpired;

  @override
  List<Object?> get props => [checkout, customerPortal];
}

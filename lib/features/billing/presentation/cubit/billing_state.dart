part of 'billing_cubit.dart';

class BillingState extends Equatable {
  const BillingState({this.checkout = const ValueWrapper<CheckoutSession?>()});

  final ValueWrapper<CheckoutSession?> checkout;

  BillingState copyWith({ValueWrapper<CheckoutSession?>? checkout}) {
    return BillingState(checkout: checkout ?? this.checkout);
  }

  bool get isLoading => checkout.isLoading;

  @override
  List<Object?> get props => [checkout];
}

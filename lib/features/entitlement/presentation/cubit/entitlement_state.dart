part of 'entitlement_cubit.dart';

class EntitlementState extends Equatable {
  const EntitlementState({
    this.checkoutStatus = const ValueWrapper(),
    this.entitlement = const ValueWrapper(),
  });

  final ValueWrapper<void> checkoutStatus;
  final ValueWrapper<Entitlement?> entitlement;

  EntitlementState copyWith({
    ValueWrapper<void>? checkoutStatus,
    ValueWrapper<Entitlement?>? entitlement,
  }) {
    return EntitlementState(
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      entitlement: entitlement ?? this.entitlement,
    );
  }

  bool get isProActive => entitlement.value?.isProActive ?? false;

  @override
  List<Object?> get props => [checkoutStatus, entitlement];
}

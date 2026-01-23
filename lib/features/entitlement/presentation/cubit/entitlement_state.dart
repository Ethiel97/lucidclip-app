part of 'entitlement_cubit.dart';

class EntitlementState extends Equatable {
  const EntitlementState({this.entitlement = const ValueWrapper()});

  final ValueWrapper<Entitlement?> entitlement;

  EntitlementState copyWith({ValueWrapper<Entitlement?>? entitlement}) {
    return EntitlementState(entitlement: entitlement ?? this.entitlement);
  }

  bool get isProActive => entitlement.value?.isProActive ?? false;

  @override
  List<Object?> get props => [entitlement];
}

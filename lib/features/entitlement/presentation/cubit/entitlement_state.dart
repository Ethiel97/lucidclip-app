part of 'entitlement_cubit.dart';

class EntitlementState extends Equatable {
  const EntitlementState({this.entitlement = const ValueWrapper()});

  factory EntitlementState.fromJson(Map<String, dynamic> json) {
    return EntitlementState(
      entitlement: ValueWrapper(
        value: json['entitlement'] != null
            ? EntitlementModel.fromJson(
                json['entitlement'] as Map<String, dynamic>,
              ).toEntity()
            : null,
      ),
    );
  }

  final ValueWrapper<Entitlement?> entitlement;

  EntitlementState copyWith({ValueWrapper<Entitlement?>? entitlement}) {
    return EntitlementState(entitlement: entitlement ?? this.entitlement);
  }

  bool get isProActive => entitlement.value?.isProActive ?? false;

  Map<String, dynamic> toJson() {
    return {
      'entitlement': entitlement.value != null
          ? EntitlementModel.fromEntity(entitlement.value!).toJson()
          : null,
    };
  }

  @override
  List<Object?> get props => [entitlement];
}

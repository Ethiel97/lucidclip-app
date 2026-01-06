part of 'auth_cubit.dart';

/// Authentication state
class AuthState extends Equatable {
  const AuthState({
    this.user = const ValueWrapper(),
  });

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      user: ValueWrapper(
        value: json['user'] != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
                .toEntity()
            : null,
      ),
    );
  }

  final ValueWrapper<User?> user;

  /// Check if user is authenticated
  bool get isAuthenticated => user.hasData && user.value != null && user.value!.isNotEmpty;

  /// Check if authentication is in progress
  bool get isLoading => user.isLoading;

  /// Check if there's an error
  bool get hasError => user.isError;

  /// Get error message if available
  String? get errorMessage => user.error?.message.toString();

  AuthState copyWith({
    ValueWrapper<User?>? user,
  }) {
    return AuthState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];

  Map<String, dynamic> toJson() {
    return {
      'user': user.value != null
          ? UserModel.fromEntity(user.value!).toJson()
          : null,
    };
  }
}

part of 'auth_cubit.dart';

/// Authentication state
class AuthState extends Equatable {
  const AuthState({
    this.logoutResult = const ValueWrapper(),
    this.user = const ValueWrapper(),
    this.logoutRequest,
  });

  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    user: ValueWrapper(
      value: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>).toEntity()
          : null,
    ),
  );

  final bool? logoutRequest;
  final ValueWrapper<void> logoutResult;
  final ValueWrapper<User?> user;

  AuthState copyWith({
    bool? logoutRequest,
    ValueWrapper<void>? logoutResult,
    ValueWrapper<User?>? user,
  }) => AuthState(
    logoutRequest: logoutRequest ?? this.logoutRequest,
    logoutResult: logoutResult ?? this.logoutResult,
    user: user ?? this.user,
  );

  /// Check if user is authenticated
  bool get isAuthenticated {
    log(
      'user.hasData: ${user.hasData}, user.isSuccess: ${user.isSuccess},'
      ' userId: $userId, userEmail: $userEmail',
    );
    return user.hasData &&
        user.isSuccess &&
        (userId?.isNotEmpty ?? false) &&
        (userEmail?.isNotEmpty ?? false);
  }

  /// Check if authentication is in progress
  bool get isAuthenticating => user.isLoading;

  /// Check if there's an error
  bool get hasError => user.isError;

  /// Get error message if available
  String? get errorMessage => user.error?.message.toString();

  /// Get user ID if available
  String? get userId => user.value?.id;

  String? get userEmail => user.value?.email;

  bool get isLogoutRequested => logoutRequest ?? false;

  bool get isLogoutDeclined => !(logoutRequest ?? false);

  @override
  List<Object?> get props => [logoutRequest, logoutResult, user];

  Map<String, dynamic> toJson() => {
    'user': user.value != null
        ? UserModel.fromEntity(user.value!).toJson()
        : null,
  };
}

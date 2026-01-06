part of 'auth_cubit.dart';

/// Authentication state
class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.status = AuthStatus.unauthenticated,
    this.errorMessage,
  });

  final User? user;
  final AuthStatus status;
  final String? errorMessage;

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  /// Check if authentication is in progress
  bool get isLoading => status == AuthStatus.loading;

  /// Check if there's an error
  bool get hasError => status == AuthStatus.error;

  AuthState copyWith({
    User? user,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [user, status, errorMessage];
}

/// Authentication status enum
enum AuthStatus {
  /// User is not authenticated
  unauthenticated,
  
  /// Authentication is in progress
  loading,
  
  /// User is authenticated
  authenticated,
  
  /// Authentication error occurred
  error,
}

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/auth/data/data.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';

/// Implementation of the AuthRepository
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  final AuthDataSource _dataSource;

  @override
  Future<User?> signInWithGitHub() async {
    final userModel = await _dataSource.signInWithGitHub();
    return userModel?.toEntity() ?? User.anonymous();
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await _dataSource.getCurrentUser();
    return userModel?.toEntity() ?? User.anonymous();
  }

  @override
  Stream<User?> get authStateChanges {
    return _dataSource.authStateChanges.map(
      (userModel) =>
          userModel == null ? User.anonymous() : userModel.toEntity(),
    );
  }

  @override
  Future<String?> get currentUserId => _dataSource.authStateChanges
      .firstWhere((user) => user != null && user.id != 'anonymous')
      .then((user) => user?.id);
}

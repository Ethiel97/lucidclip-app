import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late StreamController<User?> authStateController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authStateController = StreamController<User?>.broadcast();

    // Setup default mock behaviors
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => null);
  });

  tearDown(() {
    authStateController.close();
  });

  group('AuthCubit', () {
    test('initial state is unauthenticated', () {
      final cubit = AuthCubit(authRepository: mockAuthRepository);
      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(cubit.state.user, isNull);
      cubit.close();
    });

    blocTest<AuthCubit, AuthState>(
      'emits authenticated state when getCurrentUser returns a user',
      setUp: () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
        );
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => user);
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthState(
          user: User(id: 'test-id', email: 'test@example.com'),
          status: AuthStatus.authenticated,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated state when getCurrentUser returns null',
      setUp: () {
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => null);
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then authenticated when signInWithGitHub succeeds',
      setUp: () {
        const user = User(
          id: 'github-id',
          email: 'github@example.com',
        );
        when(() => mockAuthRepository.signInWithGitHub())
            .thenAnswer((_) async => user);
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) => cubit.signInWithGitHub(),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(
          user: User(id: 'github-id', email: 'github@example.com'),
          status: AuthStatus.authenticated,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then error when signInWithGitHub fails',
      setUp: () {
        when(() => mockAuthRepository.signInWithGitHub())
            .thenThrow(Exception('OAuth failed'));
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) => cubit.signInWithGitHub(),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.error)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('Failed to sign in with GitHub'),
            ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when signOut is called',
      setUp: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      seed: () => const AuthState(
        user: User(id: 'test-id', email: 'test@example.com'),
        status: AuthStatus.authenticated,
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits authenticated when auth state stream emits a user',
      setUp: () {
        const user = User(
          id: 'stream-id',
          email: 'stream@example.com',
        );
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => null);
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) {
        authStateController.add(
          const User(id: 'stream-id', email: 'stream@example.com'),
        );
      },
      skip: 1, // Skip initial state
      expect: () => [
        const AuthState(
          user: User(id: 'stream-id', email: 'stream@example.com'),
          status: AuthStatus.authenticated,
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when auth state stream emits null',
      setUp: () {
        const user = User(
          id: 'test-id',
          email: 'test@example.com',
        );
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => user);
      },
      build: () => AuthCubit(authRepository: mockAuthRepository),
      act: (cubit) {
        authStateController.add(null);
      },
      skip: 1, // Skip initial authenticated state
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated),
      ],
    );
  });
}

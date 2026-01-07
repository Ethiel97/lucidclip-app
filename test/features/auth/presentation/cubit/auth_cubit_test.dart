import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_clip/core/utils/utils.dart';
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
    test('initial state has no user', () {
      final cubit = AuthCubit(authRepository: mockAuthRepository);
      expect(cubit.state.user.value, isNull);
      expect(cubit.state.isAuthenticated, isFalse);
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
        isA<AuthState>()
            .having(
              (s) => s.user.value?.id,
              'user id',
              'test-id',
            )
            .having(
              (s) => s.isAuthenticated,
              'isAuthenticated',
              isTrue,
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
        isA<AuthState>()
            .having(
              (s) => s.user.value,
              'user',
              isNull,
            )
            .having(
              (s) => s.isAuthenticated,
              'isAuthenticated',
              isFalse,
            ),
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
        isA<AuthState>().having((s) => s.isLoading, 'isLoading', isTrue),
        isA<AuthState>()
            .having((s) => s.user.value?.id, 'user id', 'github-id')
            .having((s) => s.isAuthenticated, 'isAuthenticated', isTrue),
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
        isA<AuthState>().having((s) => s.isLoading, 'isLoading', isTrue),
        isA<AuthState>()
            .having((s) => s.hasError, 'hasError', isTrue)
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
        user: ValueWrapper(
          value: User(id: 'test-id', email: 'test@example.com'),
          status: Status.success,
        ),
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.user.value, 'user', isNull)
            .having((s) => s.isAuthenticated, 'isAuthenticated', isFalse),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits authenticated when auth state stream emits a user',
      setUp: () {
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
        isA<AuthState>()
            .having((s) => s.user.value?.id, 'user id', 'stream-id')
            .having((s) => s.isAuthenticated, 'isAuthenticated', isTrue),
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
        isA<AuthState>()
            .having((s) => s.user.value, 'user', isNull)
            .having((s) => s.isAuthenticated, 'isAuthenticated', isFalse),
      ],
    );
  });
}

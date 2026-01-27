import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';
import 'package:lucid_clip/features/entitlement/domain/domain.dart';

part 'entitlement_state.dart';

@lazySingleton
class EntitlementCubit extends Cubit<EntitlementState> {
  EntitlementCubit({
    required this.authRepository,
    required this.entitlementRepository,
  }) : super(const EntitlementState()) {
    _authSubscription = authRepository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  String? _currentUserId;

  final AuthRepository authRepository;
  final EntitlementRepository entitlementRepository;
  late StreamSubscription<User?>? _authSubscription;
  StreamSubscription<Entitlement?>? _localSubscription;

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      await _reset();
      return;
    }

    if (_currentUserId == user.id && _localSubscription != null) {
      return;
    }

    if (_currentUserId != null && _currentUserId != user.id) {
      await _reset();
    }

    await boot(user.id);
  }

  Future<void> _reset() async {
    await entitlementRepository.stopRealtime();
    await _localSubscription?.cancel();
    _localSubscription = null;
    _currentUserId = null;
    emit(const EntitlementState());
  }

  Future<void> boot(String userId) async {
    _currentUserId = userId;

    emit(state.copyWith(entitlement: state.entitlement.toLoading()));

    try {
      // Start local stream first (fast UI updates)
      await _localSubscription?.cancel();
      _localSubscription = entitlementRepository.watchLocal(userId).listen((e) {
        log('EntitlementCubit: local entitlement updated: $e');
        emit(state.copyWith(entitlement: state.entitlement.toSuccess(e)));
      });

      // Load local + trigger refresh
      final local = await entitlementRepository.load(userId);
      emit(state.copyWith(entitlement: state.entitlement.toSuccess(local)));

      // Start realtime (upgrade instantly after webhook)
      await entitlementRepository.startRealtime(userId);
    } catch (e) {
      emit(
        state.copyWith(
          entitlement: state.entitlement.toError(
            ErrorDetails(message: 'Failed to load entitlements: $e'),
          ),
        ),
      );
    }
  }

  Future<void> refresh(String userId) async {
    try {
      await entitlementRepository.refresh(userId);
    } catch (_) {
      // silent: UI already has local value; realtime may catch later
    }
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await entitlementRepository.stopRealtime();
    await _authSubscription?.cancel();
    await _localSubscription?.cancel();
    return super.close();
  }
}

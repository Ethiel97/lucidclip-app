import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';
import 'package:lucid_clip/features/entitlement/domain/domain.dart';

part 'entitlement_state.dart';

@lazySingleton
class EntitlementCubit extends HydratedCubit<EntitlementState> {
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
    final effectiveUser = user ?? User.anonymous();

    if (effectiveUser.isAnonymous) {
      await _reset();
      return;
    }

    if (_currentUserId == effectiveUser.id && _localSubscription != null) {
      return;
    }

    if (_currentUserId != null && _currentUserId != effectiveUser.id) {
      await _reset();
    }

    await boot(effectiveUser.id);
  }

  Future<void> _reset() async {
    await entitlementRepository.stopRealtime();
    await _localSubscription?.cancel();
    if (_currentUserId != null) {
      entitlementRepository.clearLocal(_currentUserId!).unawaited();
    }
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
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          entitlement: state.entitlement.toError(
            ErrorDetails(message: 'Failed to load entitlements: $error'),
          ),
        ),
      );

      Observability.captureException(
        error,
        stackTrace: stackTrace,
        hint: {'operation': 'load_entitlements'},
      ).unawaited();

      Observability.breadcrumb(
        'Error loading entitlements',
        category: 'entitlement',
        level: ObservabilityLevel.error,
      ).unawaited();
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

  @override
  EntitlementState? fromJson(Map<String, dynamic> json) {
    try {
      return EntitlementState.fromJson(json);
    } catch (e) {
      log('EntitlementCubit: fromJson error: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(EntitlementState state) {
    try {
      return state.toJson();
    } catch (e) {
      log('EntitlementCubit: toJson error: $e');
      return null;
    }
  }
}

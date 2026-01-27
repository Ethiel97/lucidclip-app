import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/billing.dart';

part 'billing_state.dart';

@lazySingleton
class BillingCubit extends HydratedCubit<BillingState> {
  BillingCubit({required this.authRepository, required this.billingRepository})
    : super(const BillingState()) {
    _boot();
  }

  final AuthRepository authRepository;
  final BillingRepository billingRepository;

  StreamSubscription<User?>? _userSubscription;

  String? currentUserId;

  Future<void> _boot() async {
    await _userSubscription?.cancel();
    _userSubscription = authRepository.authStateChanges.listen((user) {
      // get the current user and get its customer portal if authenticated
      // it should handle cases where the user is already logged in
      // to avoid duplicate calls
      if (user != null && user.id != currentUserId) {
        currentUserId = user.id;
        getCustomerPortal();
      } else if (user == null) {
        currentUserId = null;
        emit(
          state.copyWith(customerPortal: const ValueWrapper<CustomerPortal>()),
        );
      }
    });
  }

  Future<void> getCustomerPortal() async {
    if (!state.needsPortalRenew) return;
    if (state.customerPortal.isLoading) return;

    emit(state.copyWith(customerPortal: state.customerPortal.toLoading()));

    try {
      final portal = await billingRepository.getCustomerPortalUrl();

      emit(state.copyWith(customerPortal: portal.toSuccess()));
    } catch (e) {
      emit(
        state.copyWith(
          customerPortal: state.customerPortal.toError(
            ErrorDetails(message: 'Failed to get customer portal: $e'),
          ),
        ),
      );
    }
  }

  /// Starts a checkout session and exposes it in state for the UI to open.
  Future<void> startCheckout({required String productId}) async {
    if (state.isLoading) return;

    emit(state.copyWith(checkout: state.checkout.toLoading()));

    try {
      final session = await billingRepository.startProCheckout(productId);

      emit(state.copyWith(checkout: session.toSuccess()));
    } catch (e) {
      emit(
        state.copyWith(
          checkout: state.checkout.toError(
            ErrorDetails(message: 'Failed to start checkout: $e'),
          ),
        ),
      );
    }
  }

  /// Call after the UI handled the success (opened URL) to avoid re-triggering.
  void clearCheckout() {
    emit(state.copyWith(checkout: const ValueWrapper<CheckoutSession>()));
  }

  @disposeMethod
  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  BillingState? fromJson(Map<String, dynamic> json) {
    try {
      return BillingState.fromJson(json);
    } catch (_) {
      log('Failed to deserialize BillingState from JSON: $json');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(BillingState state) {
    try {
      return state.toJson();
    } catch (_) {
      log('Failed to serialize BillingState to JSON: $state');
      return null;
    }
  }
}

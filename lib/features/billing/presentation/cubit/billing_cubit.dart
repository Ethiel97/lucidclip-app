import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/billing/domain/domain.dart';

part 'billing_state.dart';

@lazySingleton
class BillingCubit extends Cubit<BillingState> {
  BillingCubit({required this.billingRepository}) : super(const BillingState());

  final BillingRepository billingRepository;

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
}

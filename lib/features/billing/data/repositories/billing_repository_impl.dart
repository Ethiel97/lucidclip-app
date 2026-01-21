import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/billing/data/data.dart';
import 'package:lucid_clip/features/billing/domain/domain.dart';

@LazySingleton(as: BillingRepository)
class BillingRepositoryImpl implements BillingRepository {
  BillingRepositoryImpl({
    required this.authDataSource,
    required this.billingRemoteDataSource,
  });

  final AuthDataSource authDataSource;
  final BillingRemoteDataSource billingRemoteDataSource;

  @override
  Future<CheckoutSession> startProCheckout(String productId) async {
    try {
      final user = (await authDataSource.getCurrentUser())!.toEntity();

      final checkoutSession = await billingRemoteDataSource
          .createCheckoutSession(
            productId: productId,
            userId: user.id,
            email: user.email,
          );

      return checkoutSession!.toEntity();
    } on ServerException catch (e) {
      throw ServerException('Failed to start pro checkout: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error starting pro checkout: $e');
    }
  }
}

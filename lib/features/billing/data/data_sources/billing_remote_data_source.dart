//ignore: one_member_abstracts
import 'package:lucid_clip/features/billing/data/data.dart';

//ignore: one_member_abstracts
abstract class BillingRemoteDataSource {
  Future<CheckoutSessionModel?> createCheckoutSession({
    required String productId,
    required String userId,
    required String? email,
  });
}

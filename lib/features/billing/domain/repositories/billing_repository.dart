import 'package:lucid_clip/features/billing/domain/domain.dart';

//ignore: one_member_abstracts
abstract class BillingRepository {
  Future<CheckoutSession> startProCheckout(String productId);

  Future<CustomerPortal> getCustomerPortalUrl();
}

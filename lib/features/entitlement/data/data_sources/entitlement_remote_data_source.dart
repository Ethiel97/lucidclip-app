import 'package:lucid_clip/features/entitlement/data/data.dart';

abstract class EntitlementRemoteSubscription {
  Stream<EntitlementModel> get stream;

  Future<void> cancel();
}

abstract class EntitlementRemoteDataSource {
  Future<EntitlementModel?> fetchEntitlement(String userId);

  Future<EntitlementRemoteSubscription> subscribeEntitlement(String userId);
}

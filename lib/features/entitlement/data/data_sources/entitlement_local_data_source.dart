import 'package:lucid_clip/features/entitlement/data/data.dart';

abstract class EntitlementLocalDataSource {
  Future<void> upsertEntitlement(EntitlementModel entitlement);

  Future<EntitlementModel?> fetchEntitlement(String userId);

  Stream<EntitlementModel?> watchEntitlement(String userId);

  Future<void> clear(String userId);
}

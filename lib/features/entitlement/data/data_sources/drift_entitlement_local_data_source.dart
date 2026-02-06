import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';

@LazySingleton(as: EntitlementLocalDataSource)
class DriftEntitlementLocalDataSource implements EntitlementLocalDataSource {
  DriftEntitlementLocalDataSource(this.db);

  final EntitlementDatabase db;

  @override
  Future<void> clear(String userId) {
    try {
      return db.deleteEntitlementByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EntitlementModel?> fetchEntitlement(String userId) async {
    try {
      final entitlement = await db.getEntitlementByUserId(userId);
      return entitlement != null ? db.entryToModel(entitlement) : null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> upsertEntitlement(EntitlementModel entitlement) {
    try {
      final companion = db.modelToCompanion(entitlement);
      return db.upsertEntitlement(companion);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<EntitlementModel?> watchEntitlement(String userId) {
    try {
      return db
          .watchEntitlementByUserId(userId)
          .map((entry) => entry != null ? db.entryToModel(entry) : null)
          .distinct((previous, next) => previous?.id == next?.id);
    } catch (e) {
      rethrow;
    }
  }
}

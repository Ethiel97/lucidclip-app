import 'package:lucid_clip/features/entitlement/domain/domain.dart';

abstract class EntitlementRepository {
  /// Returns local value if present, then attempts remote refresh.
  Future<Entitlement?> load(String userId);

  /// Force a remote refresh (and persist locally).
  Future<Entitlement?> refresh(String userId);

  /// Local stream (what UI should primarily listen to).
  Stream<Entitlement?> watchLocal(String userId);

  /// Subscribe remote realtime (websocket/channel). Must be cancellable.
  Future<void> startRealtime(String userId);

  Future<void> stopRealtime();

  Future<void> clearLocal(String userId);
}

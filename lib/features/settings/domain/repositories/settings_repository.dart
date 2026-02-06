import 'package:lucid_clip/features/settings/domain/entities/entities.dart';

abstract class SettingsRepository {
  /// Returns local value if present, then attempts remote refresh.
  Future<UserSettings?> load(String userId);

  /// Force a remote refresh (and persist locally).
  Future<UserSettings?> refresh(String userId);

  /// Update settings (persists locally and syncs to remote if authenticated).
  Future<void> update(UserSettings settings);

  /// Local stream (what UI should primarily listen to).
  Stream<UserSettings?> watchLocal(String userId);

  /// Subscribe remote realtime (websocket/channel). Must be cancellable.
  Future<void> startRealtime(String userId);

  Future<void> stopRealtime();

  Future<void> clearLocal(String userId);
}

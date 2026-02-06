import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/features/settings/data/data.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsLocalDataSource local,
    required SettingsRemoteDataSource remote,
    required this.iconService,
  }) : _local = local,
       _remote = remote;

  final SettingsLocalDataSource _local;
  final SettingsRemoteDataSource _remote;
  final SourceAppIconService iconService;

  SettingsRemoteSubscription? _remoteSub;
  StreamSubscription<UserSettingsModel>? _remoteStreamSub;

  @override
  Stream<UserSettings?> watchLocal(String userId) {
    return _local.watchSettings(userId).asyncMap((model) async {
      if (model == null) return null;

      final entity = model.toEntity();

      try {
        final excluded = entity.excludedApps;
        if (excluded.isEmpty) return entity;

        final updatedExcludedApps = <SourceApp>[];
        for (final app in excluded) {
          try {
            final icon = await iconService.getIcon(app.bundleId);
            updatedExcludedApps.add(app.copyWith(icon: icon ?? app.icon));
          } catch (_) {
            updatedExcludedApps.add(app);
          }
        }

        return entity.copyWith(excludedApps: updatedExcludedApps);
      } catch (_) {
        return entity;
      }
    });
  }

  @override
  Future<UserSettings?> load(String userId) async {
    var local = await _local.getSettings(userId);

    if (local == null) {
      final defaultSettings = _createDefaultSettings(userId);
      await update(defaultSettings);
      local = await _local.getSettings(userId);
    }

    // 3) best-effort refresh (do not block UI)
    // ignore: unawaited_futures
    refresh(userId);

    return local?.toEntity();
  }

  UserSettings _createDefaultSettings(String userId) => UserSettings(
    userId: userId,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
    shortcuts: {
      'toggle_window': Platform.isMacOS
          ? 'Cmd + Shift + L'
          : 'Ctrl + Shift + L',
    },
  );

  @override
  Future<UserSettings?> refresh(String userId) async {
    try {
      final remote = await _remote.fetchSettings(userId);

      if (remote == null) {
        final local = await _local.getSettings(userId);
        return local?.toEntity();
      }

      await _local.upsertSettings(remote);
      return remote.toEntity();
    } catch (e, stack) {
      log(
        'SettingsRepositoryImpl.refresh: remote fetch failed: $e',
        stackTrace: stack,
      );

      final local = await _local.getSettings(userId);

      if (local != null) {
        return local.toEntity();
      }

      rethrow;
    }
  }

  @override
  Future<void> update(UserSettings settings) async {
    try {
      final updatedSettings = settings.copyWith(
        updatedAt: DateTime.now().toUtc(),
      );

      final model = UserSettingsModel.fromEntity(updatedSettings);

      // Update local first for immediate feedback
      await _local.upsertSettings(model);

      // Try to sync to remote (best effort)
      try {
        await _remote.upsertSettings(model.toJson());
      } catch (e) {
        log(
          'SettingsRepositoryImpl.update: remote sync failed: $e',
          name: 'SettingsRepository',
        );
        // Don't throw - local update succeeded
      }
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to update settings: $e');
    }
  }

  @override
  Future<void> startRealtime(String userId) async {
    await stopRealtime(); // avoid duplicates

    _remoteSub = await _remote.subscribeSettings(userId);

    _remoteStreamSub = _remoteSub!.stream.listen(
      (model) async {
        // Realtime → local cache (single source for UI)
        log(
          'SettingsRepositoryImpl.startRealtime: '
          'received remote update: $model',
        );
        await _local.upsertSettings(model);
      },
      onError: (_) {
        log('SettingsRepositoryImpl.startRealtime: remote subscription error');
        // Important: do NOT crash. You already have refresh() fallback.
      },
    );
  }

  @override
  Future<void> stopRealtime() async {
    await _remoteStreamSub?.cancel();
    _remoteStreamSub = null;

    await _remoteSub?.cancel();
    _remoteSub = null;
  }

  @override
  Future<void> clearLocal(String userId) => _local.deleteSettings(userId);
}

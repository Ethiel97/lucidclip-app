import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';
import 'package:lucid_clip/features/entitlement/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: EntitlementRepository)
class EntitlementRepositoryImpl implements EntitlementRepository {
  EntitlementRepositoryImpl({
    required EntitlementLocalDataSource local,
    required EntitlementRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final EntitlementLocalDataSource _local;
  final EntitlementRemoteDataSource _remote;

  EntitlementRemoteSubscription? _remoteSub;
  StreamSubscription<EntitlementModel>? _remoteStreamSub;

  final Map<String, Stream<Entitlement?>> _watchLocalCache = {};

  @override
  Stream<Entitlement?> watchLocal(String userId) =>
      _watchLocalCache.putIfAbsent(
        userId,
        () => _local
            .watchEntitlement(userId)
            .map((model) => model?.toEntity())
            .shareReplay(maxSize: 1),
      );

  @override
  Future<Entitlement?> load(String userId) async {
    // 1) local first
    final local = await _local.fetchEntitlement(userId);
    // 2) best-effort refresh (do not block UI)
    // ignore: unawaited_futures
    refresh(userId);
    return local?.toEntity();
  }

  @override
  Future<Entitlement?> refresh(String userId) async {
    try {
      final remote = await _remote.fetchEntitlement(userId);

      if (remote == null) {
        final local = await _local.fetchEntitlement(userId);
        return local?.toEntity();
      }

      await _local.upsertEntitlement(remote);
      return remote.toEntity();
    } catch (e, stack) {
      log(
        'EntitlementRepositoryImpl.refresh: remote fetch failed: $e',
        stackTrace: stack,
      );

      final local = await _local.fetchEntitlement(userId);

      if (local != null) {
        return local.toEntity();
      }

      rethrow;
    }
  }

  @override
  Future<void> startRealtime(String userId) async {
    await stopRealtime(); // avoid duplicates

    _remoteSub = await _remote.subscribeEntitlement(userId);
    _remoteStreamSub = _remoteSub!.stream.listen(
      (model) async {
        // Realtime → local cache (single source for UI)
        log(
          'EntitlementRepositoryImpl.startRealtime: received remote update:'
          ' $model',
        );
        await _local.upsertEntitlement(model);
      },
      onError: (_) {
        log(
          'EntitlementRepositoryImpl.startRealtime: remote subscription error',
        );
        // Important: do NOT crash. You already have refresh() fallback.
      },
      cancelOnError: false,
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
  Future<void> clearLocal(String userId) async {
    await _local.clear(userId);
    _watchLocalCache.remove(userId);
  }
}

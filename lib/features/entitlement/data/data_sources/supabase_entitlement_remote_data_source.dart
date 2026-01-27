// lib/features/entitlement/data/datasources/supabase_entitlement_remote_datasource.dart

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/network/network.dart';
import 'package:lucid_clip/features/entitlement/data/data.dart';

@LazySingleton(as: EntitlementRemoteDataSource)
class SupabaseEntitlementRemoteDataSource
    implements EntitlementRemoteDataSource {
  SupabaseEntitlementRemoteDataSource(this.remoteSync);

  final RemoteSyncClient remoteSync;

  static const entitlementTable = 'entitlements';

  @override
  Future<EntitlementModel?> fetchEntitlement(String userId) async {
    final response = await remoteSync.fetch(
      table: entitlementTable,
      limit: 1,
      filters: {'user_id': userId},
    );

    if (response.isEmpty) return null;
    return EntitlementModel.fromJson(response.first);
  }

  @override
  Future<EntitlementRemoteSubscription> subscribeEntitlement(
    String userId,
  ) async {
    //We keep the latest entitlement only
    final rawStream = remoteSync.watch<Map<String, dynamic>>(
      table: entitlementTable,
      primaryKey: 'user_id',
      filters: {'user_id': userId},
    );

    return _SupabaseEntitlementRemoteSubscription(rawStream);
  }
}

class _SupabaseEntitlementRemoteSubscription
    implements EntitlementRemoteSubscription {
  _SupabaseEntitlementRemoteSubscription(this._rawStream);

  final Stream<List<Map<String, dynamic>>> _rawStream;

  StreamSubscription<List<Map<String, dynamic>>>? _sub;
  final _controller = StreamController<EntitlementModel>.broadcast();

  bool _started = false;

  @override
  Stream<EntitlementModel> get stream {
    if (!_started) {
      _started = true;
      _sub = _rawStream.listen((rows) {
        if (rows.isEmpty) return;

        final latest = rows.last;
        _controller.add(EntitlementModel.fromJson(latest));
      }, onError: _controller.addError);
    }
    return _controller.stream.distinct(
      (a, b) => a.toJson().toString() == b.toJson().toString(),
    );
  }

  @override
  Future<void> cancel() async {
    await _sub?.cancel();
    await _controller.close();
  }
}

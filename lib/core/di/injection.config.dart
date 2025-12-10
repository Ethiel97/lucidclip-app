// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lucid_clip/core/clipboard_manager/base_clipboard_manager.dart'
    as _i1016;
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart'
    as _i108;
import 'package:lucid_clip/core/clipboard_manager/impl/flutter_clipboard_manager.dart'
    as _i647;
import 'package:lucid_clip/core/di/third_party_module.dart' as _i778;
import 'package:lucid_clip/core/network/impl/supabase_remote_sync.dart'
    as _i1033;
import 'package:lucid_clip/core/network/network.dart' as _i183;
import 'package:lucid_clip/core/network/remote_sync_client.dart' as _i70;
import 'package:lucid_clip/core/storage/impl/flutter_secure_storage_service.dart'
    as _i923;
import 'package:lucid_clip/core/storage/impl/hive_storage_service.dart'
    as _i443;
import 'package:lucid_clip/core/storage/storage.dart' as _i407;
import 'package:lucid_clip/features/clipboard/clipboard.dart' as _i42;
import 'package:lucid_clip/features/clipboard/data/data.dart' as _i669;
import 'package:lucid_clip/features/clipboard/data/data_sources/drift_clipboard_local_data_source.dart'
    as _i158;
import 'package:lucid_clip/features/clipboard/data/data_sources/supabase_remote_data_source.dart'
    as _i272;
import 'package:lucid_clip/features/clipboard/data/repositories/local_repository_impl.dart'
    as _i752;
import 'package:lucid_clip/features/clipboard/data/repositories/supabase_repository_impl.dart'
    as _i244;
import 'package:lucid_clip/features/clipboard/domain/domain.dart' as _i782;
import 'package:lucid_clip/features/clipboard/presentation/cubit/clipboard_cubit.dart'
    as _i958;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModule = _$ThirdPartyModule();
    gh.factory<_i669.ClipboardDatabase>(
        () => thirdPartyModule.clipboardDatabase);
    gh.lazySingleton<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.lazySingleton<_i454.SupabaseClient>(() => thirdPartyModule.supabase);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => thirdPartyModule.flutterSecureStorage);
    gh.lazySingleton<_i1016.BaseClipboardManager>(
      () => _i647.FlutterClipboardManager(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i407.SecureStorageService>(
      () => _i923.FlutterSecureStorageService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingletonAsync<_i407.StorageService>(
      () {
        final i = _i443.HiveStorageService(
            gh<List<_i986.TypeAdapter<dynamic>>>(instanceName: 'hiveAdapters'));
        return i.initialize().then((_) => i);
      },
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i669.ClipboardLocalDataSource>(() =>
        _i158.DriftClipboardLocalDataSource(gh<_i669.ClipboardDatabase>()));
    gh.singleton<_i70.RemoteSyncClient>(
        () => _i1033.SupabaseRemoteSync(supabase: gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i782.LocalClipboardRepository>(() =>
        _i752.LocalClipboardStoreImpl(gh<_i669.ClipboardLocalDataSource>()));
    gh.lazySingleton<_i42.ClipboardRemoteDataSource>(() =>
        _i272.SupabaseRemoteDataSource(
            networkClient: gh<_i183.RemoteSyncClient>()));
    gh.lazySingleton<_i42.ClipboardRepository>(() =>
        _i244.SupabaseRepositoryImpl(
            remoteDataSource: gh<_i42.ClipboardRemoteDataSource>()));
    gh.lazySingleton<_i958.ClipboardCubit>(
      () => _i958.ClipboardCubit(
        clipboardManager: gh<_i108.BaseClipboardManager>(),
        clipboardRepository: gh<_i42.ClipboardRepository>(),
      ),
      dispose: (i) => i.close(),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i778.ThirdPartyModule {}

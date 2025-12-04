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
import 'package:lucid_clip/core/clipboard_manager/impl/flutter_clipboard_manager.dart'
    as _i647;
import 'package:lucid_clip/core/di/third_party_module.dart' as _i778;
import 'package:lucid_clip/core/storage/impl/flutter_secure_storage_service.dart'
    as _i923;
import 'package:lucid_clip/core/storage/impl/hive_storage_service.dart'
    as _i443;
import 'package:lucid_clip/core/storage/storage.dart' as _i407;
import 'package:lucid_clip/features/clipboard/clipboard.dart' as _i42;
import 'package:lucid_clip/features/clipboard/data/data_sources/supabase_remote_data_source.dart'
    as _i272;

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
    gh.lazySingleton<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => thirdPartyModule.flutterSecureStorage);
    gh.lazySingleton<_i1016.BaseClipboardManager>(
        () => _i647.FlutterClipboardManager());
    gh.lazySingleton<_i407.SecureStorageService>(
      () => _i923.FlutterSecureStorageService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i42.ClipboardRemoteDataSource>(
        () => _i272.SupabaseRemoteDataSource());
    gh.lazySingletonAsync<_i407.StorageService>(
      () {
        final i = _i443.HiveStorageService(
            gh<List<_i986.TypeAdapter<dynamic>>>(instanceName: 'hiveAdapters'));
        return i.initialize().then((_) => i);
      },
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i778.ThirdPartyModule {}

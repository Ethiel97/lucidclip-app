// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
import 'package:lucid_clip/core/platform/source_app/method_channel_source_app_provider.dart'
    as _i740;
import 'package:lucid_clip/core/platform/source_app/source_app.dart' as _i51;
import 'package:lucid_clip/core/services/tray_manager_service.dart' as _i926;
import 'package:lucid_clip/core/storage/impl/flutter_secure_storage_service.dart'
    as _i923;
import 'package:lucid_clip/core/storage/impl/hive_storage_service.dart'
    as _i443;
import 'package:lucid_clip/core/storage/storage.dart' as _i407;
import 'package:lucid_clip/features/auth/auth.dart' as _i895;
import 'package:lucid_clip/features/auth/data/data.dart' as _i13;
import 'package:lucid_clip/features/auth/data/data_sources/supabase_auth_data_source.dart'
    as _i647;
import 'package:lucid_clip/features/auth/data/repositories/auth_repository_impl.dart'
    as _i409;
import 'package:lucid_clip/features/auth/domain/domain.dart' as _i922;
import 'package:lucid_clip/features/auth/presentation/cubit/auth_cubit.dart'
    as _i408;
import 'package:lucid_clip/features/clipboard/clipboard.dart' as _i42;
import 'package:lucid_clip/features/clipboard/data/data.dart' as _i669;
import 'package:lucid_clip/features/clipboard/data/data_sources/drift_clipboard_history_local_data_source.dart'
    as _i988;
import 'package:lucid_clip/features/clipboard/data/data_sources/drift_clipboard_local_data_source.dart'
    as _i158;
import 'package:lucid_clip/features/clipboard/data/data_sources/supabase_remote_data_source.dart'
    as _i272;
import 'package:lucid_clip/features/clipboard/data/repositories/local_clipboard_history_repository_impl.dart'
    as _i354;
import 'package:lucid_clip/features/clipboard/data/repositories/local_repository_impl.dart'
    as _i752;
import 'package:lucid_clip/features/clipboard/data/repositories/supabase_repository_impl.dart'
    as _i244;
import 'package:lucid_clip/features/clipboard/domain/domain.dart' as _i782;
import 'package:lucid_clip/features/clipboard/presentation/cubit/clipboard_cubit.dart'
    as _i958;
import 'package:lucid_clip/features/clipboard/presentation/cubit/clipboard_detail_cubit.dart'
    as _i68;
import 'package:lucid_clip/features/clipboard/presentation/cubit/search_cubit.dart'
    as _i997;
import 'package:lucid_clip/features/clipboard/presentation/cubit/sidebar_cubit.dart'
    as _i677;
import 'package:lucid_clip/features/settings/data/data.dart' as _i739;
import 'package:lucid_clip/features/settings/data/data_sources/data_sources.dart'
    as _i173;
import 'package:lucid_clip/features/settings/data/data_sources/drift_settings_local_data_source.dart'
    as _i386;
import 'package:lucid_clip/features/settings/data/data_sources/settings_local_data_source.dart'
    as _i72;
import 'package:lucid_clip/features/settings/data/data_sources/settings_remote_data_source.dart'
    as _i509;
import 'package:lucid_clip/features/settings/data/data_sources/supabase_settings_remote_data_source.dart'
    as _i175;
import 'package:lucid_clip/features/settings/data/db/settings_database.dart'
    as _i684;
import 'package:lucid_clip/features/settings/data/repositories/local_settings_repository_impl.dart'
    as _i958;
import 'package:lucid_clip/features/settings/data/repositories/settings_repository_impl.dart'
    as _i758;
import 'package:lucid_clip/features/settings/domain/domain.dart' as _i340;
import 'package:lucid_clip/features/settings/presentation/cubit/settings_cubit.dart'
    as _i966;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    gh.singleton<_i669.ClipboardDatabase>(
      () => thirdPartyModule.clipboardDatabase,
    );
    gh.singleton<_i739.SettingsDatabase>(
      () => thirdPartyModule.settingsDatabase,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.lazySingleton<_i454.SupabaseClient>(() => thirdPartyModule.supabase);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => thirdPartyModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i926.TrayManagerService>(
      () => _i926.TrayManagerService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i677.SidebarCubit>(
      () => _i677.SidebarCubit(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i51.SourceAppProvider>(
      () => _i740.MethodChannelSourceAppProvider(),
    );
    gh.lazySingleton<_i407.SecureStorageService>(
      () => _i923.FlutterSecureStorageService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1016.BaseClipboardManager>(
      () => _i647.FlutterClipboardManager(
        sourceAppProvider: gh<_i51.SourceAppProvider>(),
      )..initialize(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingletonAsync<_i407.StorageService>(() {
      final i = _i443.HiveStorageService(
        gh<List<_i986.TypeAdapter<dynamic>>>(instanceName: 'hiveAdapters'),
      );
      return i.initialize().then((_) => i);
    }, dispose: (i) => i.dispose());
    gh.lazySingleton<_i669.ClipboardLocalDataSource>(
      () => _i158.DriftClipboardLocalDataSource(gh<_i669.ClipboardDatabase>()),
      dispose: (i) => i.clear(),
    );
    gh.lazySingleton<_i669.ClipboardHistoryLocalDataSource>(
      () => _i988.DriftClipboardHistoryLocalDataSource(
        gh<_i669.ClipboardDatabase>(),
      ),
      dispose: (i) => i.clear(),
    );
    gh.lazySingleton<_i72.SettingsLocalDataSource>(
      () => _i386.DriftSettingsLocalDataSource(gh<_i684.SettingsDatabase>()),
    );
    gh.lazySingleton<_i13.AuthDataSource>(
      () => _i647.SupabaseAuthDataSource(
        supabaseClient: gh<_i454.SupabaseClient>(),
        secureStorage: gh<_i407.SecureStorageService>(),
      ),
    );
    gh.singleton<_i70.RemoteSyncClient>(
      () => _i1033.SupabaseRemoteSync(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i782.LocalClipboardHistoryRepository>(
      () => _i354.LocalClipboardHistoryStoreImpl(
        gh<_i669.ClipboardHistoryLocalDataSource>(),
      ),
      dispose: (i) => i.clear(),
    );
    gh.lazySingleton<_i782.LocalClipboardRepository>(
      () => _i752.LocalClipboardStoreImpl(gh<_i669.ClipboardLocalDataSource>()),
      dispose: (i) => i.clear(),
    );
    gh.lazySingleton<_i68.ClipboardDetailCubit>(
      () => _i68.ClipboardDetailCubit(
        localClipboardRepository: gh<_i782.LocalClipboardRepository>(),
        localClipboardHistoryRepository:
            gh<_i782.LocalClipboardHistoryRepository>(),
      ),
    );
    gh.lazySingleton<_i340.LocalSettingsRepository>(
      () => _i958.LocalSettingsRepositoryImpl(
        gh<_i173.SettingsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i922.AuthRepository>(
      () => _i409.AuthRepositoryImpl(dataSource: gh<_i13.AuthDataSource>()),
    );
    gh.lazySingleton<_i408.AuthCubit>(
      () => _i408.AuthCubit(authRepository: gh<_i922.AuthRepository>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i509.SettingsRemoteDataSource>(
      () => _i175.SupabaseSettingsRemoteDataSource(
        networkClient: gh<_i183.RemoteSyncClient>(),
      ),
    );
    gh.lazySingleton<_i42.ClipboardRemoteDataSource>(
      () => _i272.SupabaseRemoteDataSource(
        networkClient: gh<_i183.RemoteSyncClient>(),
      ),
    );
    gh.lazySingleton<_i997.SearchCubit>(
      () => _i997.SearchCubit(
        localClipboardRepository: gh<_i782.LocalClipboardRepository>(),
      ),
    );
    gh.lazySingleton<_i340.SettingsRepository>(
      () => _i758.SettingsRepositoryImpl(
        remoteDataSource: gh<_i173.SettingsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i42.ClipboardRepository>(
      () => _i244.SupabaseRepositoryImpl(
        remoteDataSource: gh<_i42.ClipboardRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i958.ClipboardCubit>(
      () => _i958.ClipboardCubit(
        authRepository: gh<_i895.AuthRepository>(),
        clipboardManager: gh<_i108.BaseClipboardManager>(),
        clipboardRepository: gh<_i42.ClipboardRepository>(),
        localClipboardRepository: gh<_i42.LocalClipboardRepository>(),
        localClipboardHistoryRepository:
            gh<_i42.LocalClipboardHistoryRepository>(),
        localSettingsRepository: gh<_i340.LocalSettingsRepository>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i966.SettingsCubit>(
      () => _i966.SettingsCubit(
        authRepository: gh<_i922.AuthRepository>(),
        localSettingsRepository: gh<_i340.LocalSettingsRepository>(),
        settingsRepository: gh<_i340.SettingsRepository>(),
      ),
      dispose: (i) => i.close(),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i778.ThirdPartyModule {}

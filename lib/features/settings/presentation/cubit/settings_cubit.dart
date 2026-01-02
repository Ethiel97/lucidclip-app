import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'settings_state.dart';

@lazySingleton
class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit({
    required this.localSettingsRepository,
    required this.settingsRepository,
  }) : super(const SettingsState());

  final LocalSettingsRepository localSettingsRepository;
  final SettingsRepository settingsRepository;

  StreamSubscription<UserSettings?>? _settingsSubscription;

  Future<void> loadSettings(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // First load from local
      final localSettings = await localSettingsRepository.getSettings(userId);

      if (localSettings != null) {
        emit(state.copyWith(settings: localSettings, isLoading: false));
      }

      // Then try to load from remote and sync
      try {
        final remoteSettings = await settingsRepository.getSettings(userId);
        if (remoteSettings != null) {
          await localSettingsRepository.upsertSettings(remoteSettings);
          emit(state.copyWith(settings: remoteSettings, isLoading: false));
        } else if (localSettings == null) {
          // Create default settings
          final defaultSettings = UserSettings(
            userId: userId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await updateSettings(defaultSettings);
        }
      } catch (e) {
        // If remote fails but we have local, that's okay
        if (localSettings == null) {
          // Create default settings locally
          final defaultSettings = UserSettings(
            userId: userId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await localSettingsRepository.upsertSettings(defaultSettings);
          emit(state.copyWith(settings: defaultSettings, isLoading: false));
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load settings: $e',
        ),
      );
    }
  }

  void watchSettings(String userId) {
    _settingsSubscription?.cancel();
    _settingsSubscription = localSettingsRepository
        .watchSettings(userId)
        .listen((settings) {
      if (settings != null) {
        emit(state.copyWith(settings: settings));
      }
    });
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      final updatedSettings = settings.copyWith(
        updatedAt: DateTime.now(),
      );

      // Update local first for immediate feedback
      await localSettingsRepository.upsertSettings(updatedSettings);
      emit(state.copyWith(settings: updatedSettings));

      // Then sync to remote in background
      try {
        await settingsRepository.updateSettings(updatedSettings);
      } catch (e) {
        // Log but don't fail if remote sync fails
        // The settings are already saved locally
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to update settings: $e',
        ),
      );
    }
  }

  Future<void> updateTheme(String theme) async {
    if (state.settings != null) {
      await updateSettings(state.settings!.copyWith(theme: theme));
    }
  }

  Future<void> updateAutoSync(bool autoSync) async {
    if (state.settings != null) {
      await updateSettings(state.settings!.copyWith(autoSync: autoSync));
    }
  }

  Future<void> updateSyncInterval(int minutes) async {
    if (state.settings != null) {
      await updateSettings(
        state.settings!.copyWith(syncIntervalMinutes: minutes),
      );
    }
  }

  Future<void> updateMaxHistoryItems(int maxItems) async {
    if (state.settings != null) {
      await updateSettings(
        state.settings!.copyWith(maxHistoryItems: maxItems),
      );
    }
  }

  Future<void> updateRetentionDays(int days) async {
    if (state.settings != null) {
      await updateSettings(state.settings!.copyWith(retentionDays: days));
    }
  }

  Future<void> updatePinOnTop(bool pinOnTop) async {
    if (state.settings != null) {
      await updateSettings(state.settings!.copyWith(pinOnTop: pinOnTop));
    }
  }

  Future<void> updateShowSourceApp(bool showSourceApp) async {
    if (state.settings != null) {
      await updateSettings(
        state.settings!.copyWith(showSourceApp: showSourceApp),
      );
    }
  }

  Future<void> updatePreviewImages(bool previewImages) async {
    if (state.settings != null) {
      await updateSettings(
        state.settings!.copyWith(previewImages: previewImages),
      );
    }
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    try {
      return state.toJson();
    } catch (e) {
      return null;
    }
  }
}

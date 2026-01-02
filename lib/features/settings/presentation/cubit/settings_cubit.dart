import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
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

  // Use a local storage key for unauthenticated users
  static const String _guestUserId = 'guest';

  UserSettings _createDefaultSettings(String userId) {
    return UserSettings(
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> loadSettings(String? userId) async {
    // Use guest userId if not authenticated
    final effectiveUserId = userId?.isNotEmpty == true ? userId! : _guestUserId;
    
    emit(state.copyWith(
      settings: state.settings.toLoading(),
    ));

    try {
      // First load from local
      final localSettings = await localSettingsRepository.getSettings(effectiveUserId);

      if (localSettings != null) {
        emit(state.copyWith(
          settings: state.settings.toSuccess(localSettings),
        ));
      }

      // Only try to sync with remote if user is authenticated
      if (userId?.isNotEmpty == true) {
        try {
          final remoteSettings = await settingsRepository.getSettings(userId!);
          if (remoteSettings != null) {
            await localSettingsRepository.upsertSettings(remoteSettings);
            emit(state.copyWith(
              settings: state.settings.toSuccess(remoteSettings),
            ));
          } else if (localSettings == null) {
            // Create default settings
            final defaultSettings = _createDefaultSettings(userId);
            await updateSettings(defaultSettings);
          }
        } catch (e) {
          // If remote fails but we have local, that's okay
          if (localSettings == null) {
            // Create default settings locally
            final defaultSettings = _createDefaultSettings(userId);
            await localSettingsRepository.upsertSettings(defaultSettings);
            emit(state.copyWith(
              settings: state.settings.toSuccess(defaultSettings),
            ));
          }
        }
      } else if (localSettings == null) {
        // Create default settings for guest
        final defaultSettings = _createDefaultSettings(_guestUserId);
        await localSettingsRepository.upsertSettings(defaultSettings);
        emit(state.copyWith(
          settings: state.settings.toSuccess(defaultSettings),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        settings: state.settings.toError(
          ErrorDetails(message: 'Failed to load settings: $e'),
        ),
      ));
    }
  }

  void watchSettings(String? userId) {
    final effectiveUserId = userId?.isNotEmpty == true ? userId! : _guestUserId;
    
    _settingsSubscription?.cancel();
    _settingsSubscription = localSettingsRepository
        .watchSettings(effectiveUserId)
        .listen((settings) {
      if (settings != null) {
        emit(state.copyWith(
          settings: state.settings.toSuccess(settings),
        ));
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
      emit(state.copyWith(
        settings: state.settings.toSuccess(updatedSettings),
      ));

      // Only sync to remote if user is authenticated (not guest)
      if (updatedSettings.userId != _guestUserId) {
        try {
          await settingsRepository.updateSettings(updatedSettings);
        } catch (e) {
          // Log but don't fail if remote sync fails
          // The settings are already saved locally
        }
      }
    } catch (e) {
      emit(state.copyWith(
        settings: state.settings.toError(
          ErrorDetails(message: 'Failed to update settings: $e'),
        ),
      ));
    }
  }

  Future<void> updateTheme(String theme) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(theme: theme));
    }
  }

  Future<void> updateAutoSync(bool autoSync) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(autoSync: autoSync));
    }
  }

  Future<void> updateSyncInterval(int minutes) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(syncIntervalMinutes: minutes),
      );
    }
  }

  Future<void> updateMaxHistoryItems(int maxItems) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(maxHistoryItems: maxItems),
      );
    }
  }

  Future<void> updateRetentionDays(int days) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(retentionDays: days));
    }
  }

  Future<void> updatePinOnTop(bool pinOnTop) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(pinOnTop: pinOnTop));
    }
  }

  Future<void> updateShowSourceApp(bool showSourceApp) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(showSourceApp: showSourceApp),
      );
    }
  }

  Future<void> updatePreviewImages(bool previewImages) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(previewImages: previewImages),
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

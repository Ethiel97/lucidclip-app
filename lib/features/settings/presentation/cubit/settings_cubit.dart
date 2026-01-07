import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/domain/domain.dart';
import 'package:lucid_clip/features/settings/data/models/models.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'settings_state.dart';

@lazySingleton
class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit({
    required this.authRepository,
    required this.localSettingsRepository,
    required this.settingsRepository,
  }) : super(const SettingsState()) {
    _initializeAuthListener();
  }

  final AuthRepository authRepository;
  final LocalSettingsRepository localSettingsRepository;
  final SettingsRepository settingsRepository;

  StreamSubscription<UserSettings?>? _settingsSubscription;

  // Use a local storage key for unauthenticated users
  String _currentUserId = '';

  void _initializeAuthListener() {
    authRepository.authStateChanges.listen((user) {
      _currentUserId = user?.id ?? 'guest';
      loadSettings();
      watchSettings();
    });
  }

  UserSettings _createDefaultSettings() {
    return UserSettings(
      userId: _currentUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(settings: state.settings.toLoading()));

    try {
      // First load from local
      final localSettings = await localSettingsRepository.getSettings(
        _currentUserId,
      );

      if (localSettings != null) {
        emit(state.copyWith(settings: state.settings.toSuccess(localSettings)));
      }

      // Only try to sync with remote if user is authenticated
      if (_currentUserId != 'guest') {
        try {
          final remoteSettings = await settingsRepository.getSettings(
            _currentUserId,
          );
          if (remoteSettings != null) {
            await localSettingsRepository.upsertSettings(remoteSettings);
            emit(
              state.copyWith(
                settings: state.settings.toSuccess(remoteSettings),
              ),
            );
          } else if (localSettings == null) {
            // Create default settings
            final defaultSettings = _createDefaultSettings();
            await updateSettings(defaultSettings);
          }
        } catch (e) {
          // If remote fails but we have local, that's okay
          if (localSettings == null) {
            // Create default settings locally
            final defaultSettings = _createDefaultSettings();
            await localSettingsRepository.upsertSettings(defaultSettings);
            emit(
              state.copyWith(
                settings: state.settings.toSuccess(defaultSettings),
              ),
            );
          }
        }
      } else if (localSettings == null) {
        // Create default settings for guest
        final defaultSettings = _createDefaultSettings();
        await localSettingsRepository.upsertSettings(defaultSettings);
        emit(
          state.copyWith(settings: state.settings.toSuccess(defaultSettings)),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          settings: state.settings.toError(
            ErrorDetails(message: 'Failed to load settings: $e'),
          ),
        ),
      );
    }
  }

  void watchSettings() {
    _settingsSubscription?.cancel();
    _settingsSubscription = localSettingsRepository
        .watchSettings(_currentUserId)
        .listen((settings) {
          if (settings != null) {
            emit(state.copyWith(settings: state.settings.toSuccess(settings)));
          }
        });
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      final updatedSettings = settings.copyWith(updatedAt: DateTime.now());

      // Update local first for immediate feedback
      await localSettingsRepository.upsertSettings(updatedSettings);
      emit(state.copyWith(settings: state.settings.toSuccess(updatedSettings)));

      // Only sync to remote if user is authenticated (not guest)
      if (updatedSettings.userId != _currentUserId) {
        try {
          await settingsRepository.updateSettings(updatedSettings);
        } catch (e) {
          // Log but don't fail if remote sync fails
          // The settings are already saved locally
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          settings: state.settings.toError(
            ErrorDetails(message: 'Failed to update settings: $e'),
          ),
        ),
      );
    }
  }

  Future<void> updateTheme(String theme) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(theme: theme));
    }
  }

  Future<void> updateAutoSync({required bool autoSync}) async {
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
      await updateSettings(currentSettings.copyWith(maxHistoryItems: maxItems));
    }
  }

  Future<void> updateRetentionDays(int days) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(retentionDays: days));
    }
  }

  Future<void> updateShowSourceApp({bool showSourceApp = true}) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(showSourceApp: showSourceApp),
      );
    }
  }

  Future<void> updatePreviewImages({bool previewImages = true}) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(previewImages: previewImages),
      );
    }
  }

  Future<void> updatePreviewLinks({bool previewLinks = true}) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(previewLinks: previewLinks),
      );
    }
  }

  Future<void> updateIncognitoMode({bool incognitoMode = false}) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(incognitoMode: incognitoMode),
      );
    }
  }

  Future<void> updateShortcuts(Map<String, String> shortcuts) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(shortcuts: shortcuts));
    }
  }

  Future<void> updateExcludedApps(List<String> excludedApps) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(excludedApps: excludedApps),
      );
    }
  }

  @disposeMethod
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

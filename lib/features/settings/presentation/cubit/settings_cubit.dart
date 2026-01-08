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
  StreamSubscription<User?>? _authSubscription;
  Timer? _incognitoSessionTimer;

  // Use a local storage key for unauthenticated users
  String _currentUserId = '';

  User? _currentUser;

  bool get isAuthenticated => _currentUser != null && _currentUserId != 'guest';

  void _initializeAuthListener() {
    _authSubscription = authRepository.authStateChanges.listen((user) {
      _currentUser = user;
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
        // Check if we need to restore or expire an active session
        await _checkAndRestorePrivateSession(localSettings);
      }

      // Only try to sync with remote if user is authenticated
      if (isAuthenticated) {
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
            // Check if we need to restore or expire an active session
            await _checkAndRestorePrivateSession(remoteSettings);
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
        // No need to restore session for new default settings
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
        .listen((settings) async {
          if (settings != null) {
            emit(state.copyWith(settings: state.settings.toSuccess(settings)));
            // Restore private session timer if needed when settings change
            await _checkAndRestorePrivateSession(settings);
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
      if (isAuthenticated) {
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
      // When disabling incognito mode, clear the session data
      await updateSettings(
        currentSettings.copyWith(
          incognitoMode: incognitoMode,
          incognitoSessionDurationMinutes: !incognitoMode
              ? null
              : currentSettings.incognitoSessionDurationMinutes,
          incognitoSessionEndTime: !incognitoMode
              ? null
              : currentSettings.incognitoSessionEndTime,
        ),
      );

      // Cancel timer when disabling incognito mode
      if (!incognitoMode) {
        _incognitoSessionTimer?.cancel();
        _incognitoSessionTimer = null;
      }
    }
  }

  /// Start a private session with an optional duration
  /// [durationMinutes] - Duration in minutes (null = until manually disabled)
  Future<void> startPrivateSession({int? durationMinutes}) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      final endTime = durationMinutes != null
          ? DateTime.now().add(Duration(minutes: durationMinutes))
          : null;

      await updateSettings(
        currentSettings.copyWith(
          incognitoMode: true,
          incognitoSessionDurationMinutes: durationMinutes,
          incognitoSessionEndTime: endTime,
        ),
      );

      // Set up timer to auto-disable when duration expires
      if (durationMinutes != null && endTime != null) {
        _incognitoSessionTimer?.cancel();
        _incognitoSessionTimer = Timer(Duration(minutes: durationMinutes), () {
          // Use try-catch to handle any potential errors
          updateIncognitoMode().catchError((error) {
            // Log error but don't propagate - timer callback can't be async
            // Error will be logged by updateIncognitoMode if it fails
          });
        });
      }
    }
  }

  /// Check if the current incognito session has expired and disable if needed
  Future<void> checkIncognitoSessionExpiry() async {
    final currentSettings = state.settings.value;
    if (currentSettings != null &&
        currentSettings.incognitoMode &&
        currentSettings.incognitoSessionEndTime != null) {
      if (DateTime.now().isAfter(currentSettings.incognitoSessionEndTime!)) {
        await updateIncognitoMode();
      }
    }
  }

  /// Check and restore the private session timer if one is active
  Future<void> _checkAndRestorePrivateSession(UserSettings settings) async {
    if (settings.incognitoMode && settings.incognitoSessionEndTime != null) {
      final now = DateTime.now();
      final endTime = settings.incognitoSessionEndTime!;

      if (now.isAfter(endTime)) {
        // Session has expired, disable it
        await updateIncognitoMode();
      } else {
        // Session is still active, restore the timer
        _incognitoSessionTimer?.cancel();
        _incognitoSessionTimer = Timer(state.remainingSessionTime!, () {
          // Use catchError to handle any potential errors
          updateIncognitoMode().catchError((error) {
            // Log error but don't propagate - timer callback can't be async
            // Error will be logged by updateIncognitoMode if it fails
          });
        });
      }
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
    _authSubscription?.cancel();
    _settingsSubscription?.cancel();
    _incognitoSessionTimer?.cancel();
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

import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/settings.dart';

part 'settings_state.dart';

@lazySingleton
class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit({
    required this.authRepository,
    required this.settingsRepository,
  }) : super(const SettingsState()) {
    _authSubscription = authRepository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  String? _currentUserId;

  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;
  late final StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserSettings?>? _localSubscription;
  Timer? _incognitoSessionTimer;

  Future<void> _onAuthStateChanged(User? user) async {
    final effectiveUser = user ?? User.anonymous();

    final isSameUser =
        _currentUserId == effectiveUser.id && _localSubscription != null;
    if (isSameUser) {
      log(
        'SettingsCubit: Auth state changed but user is '
        'the same (${effectiveUser.id}), no action needed.',
      );
      return;
    }

    if (_currentUserId != null && _currentUserId != effectiveUser.id) {
      await _reset();
    }

    await boot(effectiveUser.id, isAnonymous: effectiveUser.isAnonymous);
  }

  Future<void> _reset() async {
    await settingsRepository.stopRealtime();
    await _localSubscription?.cancel();
    _localSubscription = null;
    _currentUserId = null;
    _incognitoSessionTimer?.cancel();
    _incognitoSessionTimer = null;
    emit(const SettingsState());
  }

  Future<void> boot(String userId, {bool isAnonymous = true}) async {
    _currentUserId = userId;

    emit(state.copyWith(settings: state.settings.toLoading()));

    try {
      // Start local stream first (fast UI updates)
      await _localSubscription?.cancel();
      _localSubscription = settingsRepository
          .watchLocal(userId)
          .listen(
            (s) {
              log('SettingsCubit: local settings updated: $s');

              if (s != null) {
                emit(state.copyWith(settings: state.settings.toSuccess(s)));
                // Restore private session timer if needed when settings change
                _checkAndRestorePrivateSession(s);
              }
            },

            onError: (Object error, StackTrace stack) {
              log(
                'SettingsCubit: error watching local settings: $error',
                stackTrace: stack,
              );
              emit(
                state.copyWith(
                  settings: state.settings.toError(
                    ErrorDetails(
                      message: 'Failed to watch local settings: $error',
                    ),
                  ),
                ),
              );

              Observability.captureException(
                error,
                stackTrace: stack,
                hint: {'operation': 'watch_local_settings'},
              ).unawaited();

              Observability.breadcrumb(
                'Local settings watch failed',
                category: 'settings',
                level: ObservabilityLevel.error,
              ).unawaited();
            },
          );

      // Load local + trigger refresh
      // Repository handles default creation if needed
      final local = await settingsRepository.load(userId);

      emit(state.copyWith(settings: state.settings.toSuccess(local)));

      if (!isAnonymous) {
        await settingsRepository.refresh(userId);
        await settingsRepository.startRealtime(userId);
      }
    } catch (refreshError, refreshStack) {
      emit(
        state.copyWith(
          settings: state.settings.toError(
            ErrorDetails(message: 'Failed to load settings: $refreshError'),
          ),
        ),
      );

      log(
        'SettingsCubit: failed to refresh settings from remote, '
        'continuing with local: $refreshError',
        stackTrace: refreshStack,
      );

      Observability.captureException(
        refreshError,
        stackTrace: refreshStack,
        hint: {'operation': 'boot_refresh_settings', 'userId': userId},
      ).unawaited();
      Observability.breadcrumb(
        'Settings refresh failed during boot, using local settings',
        category: 'settings',
        level: ObservabilityLevel.warning,
      ).unawaited();
    }
  }

  Future<void> refresh(String userId) async {
    try {
      await settingsRepository.refresh(userId);
    } catch (e, stack) {
      log(
        'SettingsCubit: error refreshing settings: $e',
        stackTrace: stack,
        name: 'SettingsCubit',
      );
      // silent: UI already has local value; realtime may catch later
    }
  }

  /// Refresh settings using the current user ID
  Future<void> refreshSettings() async {
    if (_currentUserId != null) {
      await refresh(_currentUserId!);
    }
  }

  Future<void> updatedExcludedApps(List<SourceApp> apps) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(currentSettings.copyWith(excludedApps: apps));
    }
  }

  Future<void> toggleAppExclusion(SourceApp? app) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null && app != null) {
      final excludedApps = List<SourceApp>.from(currentSettings.excludedApps);
      if (excludedApps.any((a) => a.bundleId == app.bundleId)) {
        excludedApps.removeWhere((a) => a.bundleId == app.bundleId);

        emit(
          state.copyWith(
            includeAppResult: state.includeAppResult.toSuccess(app),
          ),
        );
      } else {
        excludedApps.add(app);
        emit(
          state.copyWith(
            excludeAppResult: state.excludeAppResult.toSuccess(app),
          ),
        );
      }
      await updateSettings(
        currentSettings.copyWith(excludedApps: excludedApps),
      );
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      await settingsRepository.update(settings);
      // No need to emit here - the watchLocal stream will emit the update
    } catch (e, stack) {
      log(
        'Error updating settings for user $_currentUserId: $e',
        stackTrace: stack,
        name: 'SettingsCubit',
      );
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
      if (incognitoMode) {
        await startPrivateSession();
      } else {
        await updateSettings(
          currentSettings.copyWith(
            incognitoMode: false,
            incognitoSessionDurationMinutes: () => null,
            incognitoSessionEndTime: () => null,
          ),
        );
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
          ? DateTime.now().toUtc().add(Duration(minutes: durationMinutes))
          : null;

      await updateSettings(
        currentSettings.copyWith(
          incognitoMode: true,
          incognitoSessionDurationMinutes: () => durationMinutes,
          incognitoSessionEndTime: () => endTime,
        ),
      );

      // Set up timer to auto-disable when duration expires
      if (durationMinutes != null && endTime != null) {
        _incognitoSessionTimer?.cancel();
        _incognitoSessionTimer = Timer(Duration(minutes: durationMinutes), () {
          // Use try-catch to handle any potential errors
          updateIncognitoMode().catchError((error) {});
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
      if (DateTime.now().toUtc().isAfter(
        currentSettings.incognitoSessionEndTime!.toUtc(),
      )) {
        await updateIncognitoMode();
      }
    }
  }

  /// Check and restore the private session timer if one is active
  Future<void> _checkAndRestorePrivateSession(UserSettings settings) async {
    if (settings.incognitoMode && settings.incognitoSessionEndTime != null) {
      final now = DateTime.now().toUtc();
      final endTime = settings.incognitoSessionEndTime!.toUtc();

      if (now.isAfter(endTime)) {
        // Session has expired, disable it
        if (state.settings.value?.incognitoMode ?? false) {
          await updateIncognitoMode();
        }
      } else {
        _incognitoSessionTimer?.cancel();
        _incognitoSessionTimer = Timer(state.remainingSessionTime!, () {
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

  Future<void> updateExcludedApps(List<SourceApp> excludedApps) async {
    final currentSettings = state.settings.value;
    if (currentSettings != null) {
      await updateSettings(
        currentSettings.copyWith(excludedApps: excludedApps),
      );
    }
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await settingsRepository.stopRealtime();
    await _authSubscription?.cancel();
    await _localSubscription?.cancel();
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

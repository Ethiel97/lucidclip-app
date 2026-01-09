part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({this.settings = const ValueWrapper()});

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      settings: ValueWrapper(
        value: json['settings'] != null
            ? UserSettingsModel.fromJson(
                json['settings'] as Map<String, dynamic>,
              ).toEntity()
            : null,
      ),
    );
  }

  final ValueWrapper<UserSettings?> settings;

  SettingsState copyWith({ValueWrapper<UserSettings?>? settings}) {
    return SettingsState(settings: settings ?? this.settings);
  }

  // add getters for easy access to settings properties
  bool get isDarkTheme => settings.value?.theme == 'dark';

  bool get isLightTheme => settings.value?.theme == 'light';

  bool get isAutoSyncEnabled => settings.value?.autoSync ?? false;

  int get syncIntervalMinutes =>
      settings.value?.syncIntervalMinutes ?? defaultSyncIntervalMinutes;

  List<SourceApp> get excludedApps => settings.value?.excludedApps ?? [];

  Map<String, String> get shortcuts => settings.value?.shortcuts ?? {};

  bool get incognitoMode => settings.value?.incognitoMode ?? false;

  bool get showSourceApp => settings.value?.showSourceApp ?? true;

  bool get previewImages => settings.value?.previewImages ?? true;

  bool get previewLinks => settings.value?.previewLinks ?? true;

  int get maxHistoryItems =>
      settings.value?.maxHistoryItems ?? defaultMaxHistoryItems;

  int get retentionDays =>
      settings.value?.retentionDays ?? defaultRetentionDays;

  /// Get remaining time for the current private session
  Duration? get remainingSessionTime {
    final currentSettings = settings.value;
    if (currentSettings != null &&
        currentSettings.incognitoMode &&
        currentSettings.incognitoSessionEndTime != null) {
      final remaining = currentSettings.incognitoSessionEndTime!.difference(
        DateTime.now(),
      );
      return remaining.isNegative ? Duration.zero : remaining;
    }
    return null;
  }

  @override
  List<Object?> get props => [settings];

  Map<String, dynamic> toJson() {
    return {
      'settings': settings.value != null
          ? UserSettingsModel.fromEntity(settings.value!).toJson()
          : null,
    };
  }
}

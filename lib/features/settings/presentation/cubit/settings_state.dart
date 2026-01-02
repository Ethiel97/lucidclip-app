part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.settings,
    this.isLoading = false,
    this.error,
  });

  final UserSettings? settings;
  final bool isLoading;
  final String? error;

  SettingsState copyWith({
    UserSettings? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, error];

  Map<String, dynamic> toJson() {
    return {
      'settings': settings != null
          ? UserSettingsModel.fromEntity(settings!).toJson()
          : null,
      'isLoading': isLoading,
      'error': error,
    };
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>,
            ).toEntity()
          : null,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }
}

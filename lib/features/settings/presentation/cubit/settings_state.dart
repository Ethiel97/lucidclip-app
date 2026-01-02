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

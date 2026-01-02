import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  const UserSettings({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.theme = 'dark',
    this.shortcuts = const {},
    this.autoSync = false,
    this.syncIntervalMinutes = 5,
    this.maxHistoryItems = 1000,
    this.retentionDays = 30,
    this.pinOnTop = true,
    this.showSourceApp = true,
    this.previewImages = true,
  });

  factory UserSettings.empty() {
    return UserSettings(
      userId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static UserSettings emptyValue = UserSettings.empty();

  bool get isEmpty => this == UserSettings.emptyValue;

  final String userId;
  final String theme;
  final Map<String, dynamic> shortcuts;
  final bool autoSync;
  final int syncIntervalMinutes;
  final int maxHistoryItems;
  final int retentionDays;
  final bool pinOnTop;
  final bool showSourceApp;
  final bool previewImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettings copyWith({
    String? userId,
    String? theme,
    Map<String, dynamic>? shortcuts,
    bool? autoSync,
    int? syncIntervalMinutes,
    int? maxHistoryItems,
    int? retentionDays,
    bool? pinOnTop,
    bool? showSourceApp,
    bool? previewImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      shortcuts: shortcuts ?? this.shortcuts,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      retentionDays: retentionDays ?? this.retentionDays,
      pinOnTop: pinOnTop ?? this.pinOnTop,
      showSourceApp: showSourceApp ?? this.showSourceApp,
      previewImages: previewImages ?? this.previewImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        theme,
        shortcuts,
        autoSync,
        syncIntervalMinutes,
        maxHistoryItems,
        retentionDays,
        pinOnTop,
        showSourceApp,
        previewImages,
        createdAt,
        updatedAt,
      ];
}

enum SettingsThemeMode {
  light,
  dark,
  system;

  bool get isLight => this == SettingsThemeMode.light;
  bool get isDark => this == SettingsThemeMode.dark;
  bool get isSystem => this == SettingsThemeMode.system;

  static SettingsThemeMode fromString(String value) {
    return switch (value.toLowerCase()) {
      'light' => SettingsThemeMode.light,
      'dark' => SettingsThemeMode.dark,
      'system' => SettingsThemeMode.system,
      _ => SettingsThemeMode.dark,
    };
  }
}

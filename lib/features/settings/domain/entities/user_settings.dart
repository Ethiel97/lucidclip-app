import 'package:equatable/equatable.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';

// TODO(Ethiel97): AUTO SYNC SETTING SHOULD BE FOR PREMIUM USERS ONLY
//  HISTORY LIMIT SHOULD BE FOR PREMIUM USERS ONLY,
//  FREE USERS GET 50 ITEMS LIMIT
//

const defaultMaxHistoryItems = 50;
const defaultRetentionDays = 1;
const defaultSyncIntervalMinutes = 30;

class UserSettings extends Equatable {
  const UserSettings({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.excludedApps = const [],
    this.theme = 'dark',
    this.shortcuts = const {},
    this.autoSync = false,
    this.syncIntervalMinutes = 5,
    this.maxHistoryItems = defaultMaxHistoryItems,
    this.retentionDays = defaultRetentionDays,
    this.showSourceApp = true,
    this.previewImages = true,
    this.previewLinks = true,
    this.incognitoMode = false,
    this.incognitoSessionDurationMinutes,
    this.incognitoSessionEndTime,
  });

  factory UserSettings.empty() {
    return UserSettings(
      userId: '',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  static UserSettings emptyValue = UserSettings.empty();

  bool get isEmpty => this == UserSettings.emptyValue;

  final String userId;
  final String theme;
  final List<SourceApp> excludedApps;
  final Map<String, String> shortcuts;
  final bool autoSync;
  final int syncIntervalMinutes;
  final int maxHistoryItems;
  final int retentionDays;
  final bool showSourceApp;
  final bool incognitoMode;
  final bool previewImages;
  final bool previewLinks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? incognitoSessionDurationMinutes; // null = until disabled
  final DateTime? incognitoSessionEndTime;

  UserSettings copyWith({
    String? userId,
    String? theme,
    Map<String, String>? shortcuts,
    List<SourceApp>? excludedApps,
    bool? autoSync,
    int? syncIntervalMinutes,
    int? maxHistoryItems,
    int? retentionDays,
    bool? showSourceApp,
    bool? previewImages,
    bool? previewLinks,
    bool? incognitoMode,
    int? incognitoSessionDurationMinutes,
    DateTime? incognitoSessionEndTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      shortcuts: shortcuts ?? this.shortcuts,
      excludedApps: excludedApps ?? this.excludedApps,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      retentionDays: retentionDays ?? this.retentionDays,
      showSourceApp: showSourceApp ?? this.showSourceApp,
      incognitoMode: incognitoMode ?? this.incognitoMode,
      previewImages: previewImages ?? this.previewImages,
      previewLinks: previewLinks ?? this.previewLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      incognitoSessionDurationMinutes:
          incognitoSessionDurationMinutes ??
          this.incognitoSessionDurationMinutes,
      incognitoSessionEndTime:
          incognitoSessionEndTime ?? this.incognitoSessionEndTime,
    );
  }

  @override
  String toString() {
    return 'UserSettings(userId: $userId, theme: $theme, '
        'excludedApps: $excludedApps, shortcuts: $shortcuts, '
        'autoSync: $autoSync, syncIntervalMinutes: $syncIntervalMinutes, '
        'maxHistoryItems: $maxHistoryItems, '
        'retentionDays: $retentionDays, showSourceApp: $showSourceApp, '
        'incognitoMode: $incognitoMode, previewImages: $previewImages, '
        'previewLinks: $previewLinks, createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'incognitoSessionDurationMinutes: $incognitoSessionDurationMinutes, '
        'incognitoSessionEndTime: $incognitoSessionEndTime)';
  }

  @override
  List<Object?> get props => [
    excludedApps,
    userId,
    theme,
    shortcuts,
    autoSync,
    syncIntervalMinutes,
    maxHistoryItems,
    retentionDays,
    showSourceApp,
    incognitoMode,
    previewImages,
    previewLinks,
    createdAt,
    updatedAt,
    incognitoSessionDurationMinutes,
    incognitoSessionEndTime,
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

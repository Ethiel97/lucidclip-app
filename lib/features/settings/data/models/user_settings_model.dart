import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/settings/domain/entities/entities.dart';

part 'user_settings_model.g.dart';

typedef UserSettingsShortcut = Map<String, String>;

@JsonSerializable(explicitToJson: true)
class UserSettingsModel extends Equatable {
  const UserSettingsModel({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.excludedApps = const [],
    this.theme = 'dark',
    this.shortcuts = const {},
    this.autoSync = false,
    this.syncIntervalMinutes = 60,
    this.maxHistoryItems = 50,
    this.retentionDays = 5,
    this.incognitoMode = false,
    this.showSourceApp = true,
    this.previewImages = true,
    this.previewLinks = true,
  });

  factory UserSettingsModel.fromEntity(UserSettings settings) {
    return UserSettingsModel(
      excludedApps: settings.excludedApps,
      userId: settings.userId,
      theme: settings.theme,
      shortcuts: settings.shortcuts,
      autoSync: settings.autoSync,
      incognitoMode: settings.incognitoMode,
      syncIntervalMinutes: settings.syncIntervalMinutes,
      maxHistoryItems: settings.maxHistoryItems,
      retentionDays: settings.retentionDays,
      showSourceApp: settings.showSourceApp,
      previewImages: settings.previewImages,
      previewLinks: settings.previewLinks,
      createdAt: settings.createdAt,
      updatedAt: settings.updatedAt,
    );
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  @JsonKey(name: 'user_id')
  final String userId;

  final String theme;

  final Map<String, String> shortcuts;

  @JsonKey(name: 'auto_sync')
  final bool autoSync;

  @JsonKey(name: 'sync_interval_minutes')
  final int syncIntervalMinutes;

  @JsonKey(name: 'max_history_items')
  final int maxHistoryItems;

  @JsonKey(name: 'retention_days')
  final int retentionDays;

  @JsonKey(name: 'show_source_app')
  final bool showSourceApp;

  @JsonKey(name: 'preview_images')
  final bool previewImages;

  @JsonKey(name: 'preview_links')
  final bool previewLinks;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'incognito_mode')
  final bool incognitoMode;

  @JsonKey(name: 'excluded_apps')
  final List<String> excludedApps;

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  UserSettingsModel copyWith({
    String? userId,
    String? theme,
    Map<String, String>? shortcuts,
    bool? autoSync,
    int? syncIntervalMinutes,
    int? maxHistoryItems,
    int? retentionDays,
    bool? showSourceApp,
    bool? previewImages,
    bool? previewLinks,
    bool? incognitoMode,
    List<String>? excludedApps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettingsModel(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      shortcuts: shortcuts ?? this.shortcuts,
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      retentionDays: retentionDays ?? this.retentionDays,
      showSourceApp: showSourceApp ?? this.showSourceApp,
      previewImages: previewImages ?? this.previewImages,
      previewLinks: previewLinks ?? this.previewLinks,
      incognitoMode: incognitoMode ?? this.incognitoMode,
      excludedApps: excludedApps ?? this.excludedApps,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  UserSettings toEntity() {
    return UserSettings(
      excludedApps: excludedApps,
      userId: userId,
      theme: theme,
      shortcuts: shortcuts,
      autoSync: autoSync,
      syncIntervalMinutes: syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems,
      retentionDays: retentionDays,
      showSourceApp: showSourceApp,
      incognitoMode: incognitoMode,
      previewImages: previewImages,
      previewLinks: previewLinks,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
    previewImages,
    previewLinks,
    createdAt,
    updatedAt,
    incognitoMode,
  ];
}

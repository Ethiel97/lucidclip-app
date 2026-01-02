import 'package:json_annotation/json_annotation.dart';
import 'package:lucid_clip/features/settings/domain/entities/entities.dart';

part 'user_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSettingsModel {
  UserSettingsModel({
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

  factory UserSettingsModel.fromEntity(UserSettings settings) {
    return UserSettingsModel(
      userId: settings.userId,
      theme: settings.theme,
      shortcuts: settings.shortcuts,
      autoSync: settings.autoSync,
      syncIntervalMinutes: settings.syncIntervalMinutes,
      maxHistoryItems: settings.maxHistoryItems,
      retentionDays: settings.retentionDays,
      pinOnTop: settings.pinOnTop,
      showSourceApp: settings.showSourceApp,
      previewImages: settings.previewImages,
      createdAt: settings.createdAt,
      updatedAt: settings.updatedAt,
    );
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  @JsonKey(name: 'user_id')
  final String userId;

  final String theme;

  final Map<String, dynamic> shortcuts;

  @JsonKey(name: 'auto_sync')
  final bool autoSync;

  @JsonKey(name: 'sync_interval_minutes')
  final int syncIntervalMinutes;

  @JsonKey(name: 'max_history_items')
  final int maxHistoryItems;

  @JsonKey(name: 'retention_days')
  final int retentionDays;

  @JsonKey(name: 'pin_on_top')
  final bool pinOnTop;

  @JsonKey(name: 'show_source_app')
  final bool showSourceApp;

  @JsonKey(name: 'preview_images')
  final bool previewImages;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  UserSettingsModel copyWith({
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
    return UserSettingsModel(
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

  UserSettings toEntity() {
    return UserSettings(
      userId: userId,
      theme: theme,
      shortcuts: shortcuts,
      autoSync: autoSync,
      syncIntervalMinutes: syncIntervalMinutes,
      maxHistoryItems: maxHistoryItems,
      retentionDays: retentionDays,
      pinOnTop: pinOnTop,
      showSourceApp: showSourceApp,
      previewImages: previewImages,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

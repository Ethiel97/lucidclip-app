// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      theme: json['theme'] as String? ?? 'dark',
      shortcuts: json['shortcuts'] as Map<String, dynamic>? ?? const {},
      autoSync: json['auto_sync'] as bool? ?? false,
      syncIntervalMinutes: json['sync_interval_minutes'] as int? ?? 5,
      maxHistoryItems: json['max_history_items'] as int? ?? 1000,
      retentionDays: json['retention_days'] as int? ?? 30,
      pinOnTop: json['pin_on_top'] as bool? ?? true,
      showSourceApp: json['show_source_app'] as bool? ?? true,
      previewImages: json['preview_images'] as bool? ?? true,
    );

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'theme': instance.theme,
      'shortcuts': instance.shortcuts,
      'auto_sync': instance.autoSync,
      'sync_interval_minutes': instance.syncIntervalMinutes,
      'max_history_items': instance.maxHistoryItems,
      'retention_days': instance.retentionDays,
      'pin_on_top': instance.pinOnTop,
      'show_source_app': instance.showSourceApp,
      'preview_images': instance.previewImages,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

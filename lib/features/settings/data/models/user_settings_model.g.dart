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
      excludedApps:
          (json['excluded_apps'] as List<dynamic>?)
              ?.map((e) => SourceAppModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      theme: json['theme'] as String? ?? 'dark',
      shortcuts:
          (json['shortcuts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      autoSync: json['auto_sync'] as bool? ?? false,
      syncIntervalMinutes:
          (json['sync_interval_minutes'] as num?)?.toInt() ??
          defaultSyncIntervalMinutes,
      maxHistoryItems:
          (json['max_history_items'] as num?)?.toInt() ??
          defaultMaxHistoryItems,
      retentionDays:
          (json['retention_days'] as num?)?.toInt() ?? defaultRetentionDays,
      incognitoMode: json['incognito_mode'] as bool? ?? false,
      showSourceApp: json['show_source_app'] as bool? ?? true,
      previewImages: json['preview_images'] as bool? ?? true,
      previewLinks: json['preview_links'] as bool? ?? true,
      incognitoSessionDurationMinutes:
          (json['incognito_session_duration_minutes'] as num?)?.toInt(),
      incognitoSessionEndTime: json['incognito_session_end_time'] == null
          ? null
          : DateTime.parse(json['incognito_session_end_time'] as String),
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
      'show_source_app': instance.showSourceApp,
      'preview_images': instance.previewImages,
      'preview_links': instance.previewLinks,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'incognito_mode': instance.incognitoMode,
      'excluded_apps': instance.excludedApps.map((e) => e.toJson()).toList(),
      'incognito_session_duration_minutes':
          instance.incognitoSessionDurationMinutes,
      'incognito_session_end_time': instance.incognitoSessionEndTime
          ?.toIso8601String(),
    };

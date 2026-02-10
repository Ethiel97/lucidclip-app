import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../observability_service.dart';

/// Sentry-based implementation of [ObservabilityService].
///
/// This implementation integrates with Sentry for error tracking,
/// breadcrumbs, and structured logging. It includes strong privacy
/// controls to prevent leaking sensitive data like clipboard contents.
///
/// Privacy features:
/// - beforeSend hook to scrub sensitive data
/// - Allowlist-based context filtering
/// - Redaction of clipboard and PII fields
@LazySingleton(as: ObservabilityService)
class SentryObservabilityService implements ObservabilityService {
  SentryObservabilityService();

  /// Allowlist of safe context keys that can be included in events.
  ///
  /// Only these keys are allowed in extra data to prevent accidental
  /// exposure of sensitive information.
  static const _allowedContextKeys = {
    // Metadata about content (not the content itself)
    'content_length',
    'content_type',
    'mime_type',
    'file_extension',
    'source',
    'category',
    'flags',
    'item_count',
    'duration_ms',
    // UI/Navigation context
    'screen',
    'route',
    'action',
    'feature',
    // System context
    'platform',
    'os_version',
    'app_version',
    'locale',
  };

  @override
  bool get isEnabled => Sentry.isEnabled;

  @override
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) async {
    if (!isEnabled) return;

    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        hint: hint != null ? Hint.withMap(hint) : null,
      );
    } catch (e, st) {
      developer.log(
        'Failed to capture exception in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    String? level,
  }) async {
    if (!isEnabled) return;

    try {
      final breadcrumb = Breadcrumb(
        message: message,
        category: category,
        data: data != null ? _filterContextData(data) : null,
        level: _parseSentryLevel(level),
        timestamp: DateTime.now(),
      );
      await Sentry.addBreadcrumb(breadcrumb);
    } catch (e, st) {
      developer.log(
        'Failed to add breadcrumb in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> captureMessage(
    String message, {
    String? level,
    Map<String, dynamic>? extras,
  }) async {
    if (!isEnabled) return;

    try {
      await Sentry.captureMessage(
        message,
        level: _parseSentryLevel(level),
        withScope: (scope) {
          if (extras != null) {
            final filtered = _filterContextData(extras);
            for (final entry in filtered.entries) {
              scope.setExtra(entry.key, entry.value);
            }
          }
        },
      );
    } catch (e, st) {
      developer.log(
        'Failed to capture message in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> setUser(
    String userId, {
    String? email,
    Map<String, String>? extras,
  }) async {
    if (!isEnabled) return;

    try {
      await Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(
            id: userId,
            email: email,
            data: extras,
          ),
        );
      });
    } catch (e, st) {
      developer.log(
        'Failed to set user in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> clearUser() async {
    if (!isEnabled) return;

    try {
      await Sentry.configureScope((scope) {
        scope.setUser(null);
      });
    } catch (e, st) {
      developer.log(
        'Failed to clear user in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> setTag(String key, String value) async {
    if (!isEnabled) return;

    try {
      await Sentry.configureScope((scope) {
        scope.setTag(key, value);
      });
    } catch (e, st) {
      developer.log(
        'Failed to set tag in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> setContext(String key, Map<String, dynamic> value) async {
    if (!isEnabled) return;

    try {
      await Sentry.configureScope((scope) {
        scope.setContexts(key, _filterContextData(value));
      });
    } catch (e, st) {
      developer.log(
        'Failed to set context in Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> close() async {
    if (!isEnabled) return;

    try {
      await Sentry.close();
    } catch (e, st) {
      developer.log(
        'Failed to close Sentry',
        error: e,
        stackTrace: st,
        name: 'SentryObservabilityService',
      );
    }
  }

  /// Filters context data to only include allowlisted keys.
  ///
  /// This is a critical privacy feature that prevents accidental
  /// leaking of sensitive data like clipboard contents or PII.
  static Map<String, dynamic> _filterContextData(Map<String, dynamic> data) {
    return Map.fromEntries(
      data.entries.where((entry) => _allowedContextKeys.contains(entry.key)),
    );
  }

  /// Parses a string level into a SentryLevel enum.
  SentryLevel _parseSentryLevel(String? level) {
    if (level == null) return SentryLevel.info;

    switch (level.toLowerCase()) {
      case 'debug':
        return SentryLevel.debug;
      case 'info':
        return SentryLevel.info;
      case 'warning':
      case 'warn':
        return SentryLevel.warning;
      case 'error':
        return SentryLevel.error;
      case 'fatal':
        return SentryLevel.fatal;
      default:
        return SentryLevel.info;
    }
  }

  /// Creates a beforeSend callback for Sentry initialization.
  ///
  /// This callback scrubs sensitive data from events before they're sent.
  /// It's designed to catch any data that might slip through other filters.
  static SentryEvent? beforeSend(SentryEvent event, Hint hint) {
    // Scrub request data if present
    if (event.request != null) {
      event = event.copyWith(
        request: event.request!.copyWith(
          data: null, // Remove request body
          cookies: null, // Remove cookies
          headers: _filterHeaders(event.request!.headers),
        ),
      );
    }

    // Filter extra data to allowlisted keys only
    if (event.extra != null) {
      event = event.copyWith(
        extra: _filterContextData(event.extra!),
      );
    }

    // Scrub breadcrumb data
    if (event.breadcrumbs != null) {
      event = event.copyWith(
        breadcrumbs: event.breadcrumbs!.map((b) {
          if (b.data == null) return b;
          return b.copyWith(
            data: _filterContextData(b.data!),
          );
        }).toList(),
      );
    }

    return event;
  }

  /// Filters HTTP headers to only include safe ones.
  static Map<String, String>? _filterHeaders(Map<String, String>? headers) {
    if (headers == null) return null;

    const safeHeaders = {
      'content-type',
      'content-length',
      'accept',
      'user-agent',
    };

    return Map.fromEntries(
      headers.entries
          .where((entry) => safeHeaders.contains(entry.key.toLowerCase())),
    );
  }
}

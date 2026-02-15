import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    'operation',
    'platform',
    'os_version',
    'app_version',
    'locale',
    'email',
    'userId',
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
      if (hint != null && hint.isNotEmpty) {
        final filteredContext = _filterContextData(hint);
        // Use withScope parameter to avoid blocking configureScope call

        Sentry.captureException(
          exception,
          stackTrace: stackTrace,
          withScope: (scope) {
            if (filteredContext.isNotEmpty) {
              for (final entry in filteredContext.entries) {
                scope.setContexts(entry.key, entry.value);
              }
            }
          },
          hint: Hint.withMap(hint),
        ).unawaited();
      } else {
        Sentry.captureException(exception, stackTrace: stackTrace).unawaited();
      }
    } catch (e, stack) {
      developer.log(
        'Failed to capture exception in Sentry',
        error: e,
        stackTrace: stack,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
    ObservabilityLevel level = ObservabilityLevel.info,
  }) async {
    if (!isEnabled) return;

    try {
      final breadcrumb = Breadcrumb(
        message: message,
        category: category,
        data: data != null ? _filterContextData(data) : null,
        level: _toSentryLevel(level),
        timestamp: DateTime.now(),
      );
      Sentry.addBreadcrumb(breadcrumb).unawaited();
    } catch (e, stack) {
      developer.log(
        'Failed to add breadcrumb in Sentry',
        error: e,
        stackTrace: stack,
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
    try {
      if (!isEnabled) return;

      // Use configureScope in a non-blocking way by not awaiting it
      // This prevents blocking the main thread while still setting the user
      Sentry.configureScope((scope) {
        scope
            .setUser(SentryUser(id: userId, email: email, data: extras))
            .unawaited();
      });
    } catch (e, stack) {
      developer.log(
        'Failed to set user in Sentry',
        error: e,
        stackTrace: stack,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      if (!isEnabled) return;

      Sentry.configureScope((scope) {
        scope.setUser(null).unawaited();
      });
    } catch (e, stack) {
      developer.log(
        'Failed to clear user in Sentry',
        error: e,
        stackTrace: stack,
        name: 'SentryObservabilityService',
      );
    }
  }

  @override
  Future<void> setTag(String key, String value) async {
    try {
      if (!isEnabled) return;

      // Use configureScope in a non-blocking way by not awaiting it
      // This prevents blocking the main thread while still setting the tag
      Sentry.configureScope((scope) {
        scope.setTag(key, value).unawaited();
      });
    } catch (e, stack) {
      developer.log(
        'Failed to set tag in Sentry',
        error: e,
        stackTrace: stack,
        name: 'SentryObservabilityService',
      );
    }
  }

  @disposeMethod
  @override
  Future<void> close() async {
    if (!isEnabled) return;

    try {
      Sentry.close().unawaited();
    } catch (e, stack) {
      developer.log(
        'Failed to close Sentry',
        error: e,
        stackTrace: stack,
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

  /// Converts ObservabilityLevel to SentryLevel enum.
  SentryLevel _toSentryLevel(ObservabilityLevel level) => switch (level) {
    ObservabilityLevel.debug => SentryLevel.debug,
    ObservabilityLevel.info => SentryLevel.info,
    ObservabilityLevel.warning => SentryLevel.warning,
    ObservabilityLevel.error => SentryLevel.error,
    ObservabilityLevel.fatal => SentryLevel.fatal,
  };

  /// Creates a beforeSend callback for Sentry initialization.
  ///
  /// This callback scrubs sensitive data from events before they're sent.
  /// It's designed to catch any data that might slip through other filters.
  static SentryEvent? beforeSend(SentryEvent event, Hint hint) {
    // Scrub request data if present

    final enrichedEvent = event;

    if (event.request != null) {
      enrichedEvent.request = event.request
        ?..headers = _filterHeaders(event.request?.headers) ?? {};
    }

    // Scrub breadcrumb data
    if (event.breadcrumbs != null) {
      enrichedEvent.breadcrumbs = event.breadcrumbs?.map((b) {
        if (b.data == null) return b;

        return b..data = _filterContextData(b.data!);
      }).toList();
    }

    return enrichedEvent;
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
      headers.entries.where(
        (entry) => safeHeaders.contains(entry.key.toLowerCase()),
      ),
    );
  }
}

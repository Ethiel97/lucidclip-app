import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/services/deep_link_service/deep_link_service_interface.dart';

/// Implementation of DeepLinkService for handling deep link callbacks
@Singleton(as: DeepLinkService)
class AppLinksDeepLinkService implements DeepLinkService {
  AppLinksDeepLinkService({required AppLinks appLinks}) : _appLinks = appLinks {
    _init();
  }

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Uri? _lastUri;

  @override
  Stream<Uri> get linkStream {
    return _appLinks.uriLinkStream;
  }

  Future<void> _init() async {
    // 1. Cold start
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      developer.log('Initial deep link: $initialUri');
      _lastUri = initialUri;
    }

    // 2. Hot stream
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        developer.log('Stream deep link: $uri');
        _lastUri = uri;
      },
      onError: (Object e, Object stack) {
        developer.log(
          'Deep link stream error',
          error: e,
          stackTrace: stack as StackTrace,
        );
      },
    );
  }

  @override
  Future<Uri?> getInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        developer.log(
          'Initial deep link received: $uri',
          name: 'DeepLinkService',
        );
      }
      return uri;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting initial link',
        error: e,
        stackTrace: stackTrace,
        name: 'DeepLinkService',
      );
      return null;
    }
  }

  @override
  Future<Uri?> waitForDeepLink({
    required Duration timeout,
    bool Function(Uri)? filter,
  }) async {
    try {
      if (_lastUri != null && (filter?.call(_lastUri!) ?? true)) {
        final uri = _lastUri!;
        _lastUri = null; // Clear after use
        return uri;
      }

      // 2️⃣ Initial link (sécurité)
      final initial = await _appLinks.getInitialLink();
      if (initial != null && (filter?.call(initial) ?? true)) {
        return initial;
      }

      // 3️⃣ Attente du stream
      return linkStream
          .where((uri) => filter?.call(uri) ?? true)
          .timeout(timeout)
          .first;
    } on TimeoutException {
      developer.log(
        'waitForDeepLink timed out after $timeout',
        name: 'DeepLinkService',
      );
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Error waiting for deep link',
        error: e,
        stackTrace: stackTrace,
        name: 'DeepLinkService',
      );
      return null;
    }
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}

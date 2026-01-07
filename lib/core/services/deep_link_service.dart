import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/services/deep_link_service_interface.dart';

/// Implementation of DeepLinkService for handling deep link callbacks
@LazySingleton(as: DeepLinkService)
class AppLinksDeepLinkService implements DeepLinkService {
  AppLinksDeepLinkService({
    required AppLinks appLinks,
  }) : _appLinks = appLinks;

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  Stream<Uri> get linkStream {
    return _appLinks.uriLinkStream;
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
    final completer = Completer<Uri?>();
    StreamSubscription<Uri>? subscription;

    // Set up timeout
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        subscription?.cancel();
        completer.complete(null);
      }
    });

    // Listen for deep links
    subscription = linkStream.listen(
      (uri) {
        developer.log(
          'Deep link received: $uri',
          name: 'DeepLinkService',
        );

        // Apply filter if provided
        if (filter != null && !filter(uri)) {
          return;
        }

        if (!completer.isCompleted) {
          timer.cancel();
          subscription?.cancel();
          completer.complete(uri);
        }
      },
      onError: (error, stackTrace) {
        developer.log(
          'Error in deep link stream',
          error: error,
          stackTrace: stackTrace,
          name: 'DeepLinkService',
        );
        if (!completer.isCompleted) {
          timer.cancel();
          subscription?.cancel();
          completer.complete(null);
        }
      },
    );

    return completer.future;
  }

  @override
  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}

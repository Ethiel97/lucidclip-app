import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';

/// Service for handling deep link callbacks, particularly for OAuth flows
@lazySingleton
class DeepLinkService {
  DeepLinkService() : _appLinks = AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  /// Listen for incoming deep links
  /// Returns a stream of URIs that the app receives
  Stream<Uri> get linkStream {
    return _appLinks.uriLinkStream;
  }

  /// Get the initial link that opened the app (if any)
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

  /// Listen for a specific deep link with a timeout
  /// Returns the URI if received within the timeout, otherwise null
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

  /// Dispose resources
  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}

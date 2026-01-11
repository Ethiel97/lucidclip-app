import 'dart:async';

/// Interface for handling deep link callbacks
abstract class DeepLinkService {
  /// Listen for incoming deep links
  /// Returns a stream of URIs that the app receives
  Stream<Uri> get linkStream;

  /// Get the initial link that opened the app (if any)
  Future<Uri?> getInitialLink();

  /// Listen for a specific deep link with a timeout
  /// Returns the URI if received within the timeout, otherwise null
  Future<Uri?> waitForDeepLink({
    required Duration timeout,
    bool Function(Uri)? filter,
  });

  /// Dispose resources
  Future<void> dispose();
}

import 'package:lucid_clip/core/storage/storage.dart';

abstract class HttpClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}

/// Extension methods for common network operations
extension NetworkExtensions on Object {
  /// Helper method to manually add auth token to headers if needed
  static Future<Map<String, String>> getAuthHeaders(
    SecureStorageService secureStorage, {
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?additionalHeaders,
    };

    try {
      final token = await secureStorage.read(
        key: SecureStorageConstants.authToken,
      );

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Ignore token retrieval errors
    }

    return headers;
  }
}

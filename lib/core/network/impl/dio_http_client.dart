import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/network/network.dart';

@LazySingleton(as: HttpClient)
class DioNetworkClient implements HttpClient {
  DioNetworkClient(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse(response);
    } on DioException catch (e, stackTrace) {
      log('DioException in POST: ${e.message}', stackTrace: stackTrace);
      throw _mapDioException(e);
    } on Exception catch (e, stackTrace) {
      log('Unexpected exception in POST: $e', stackTrace: stackTrace);
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response<dynamic> response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! <= 401) {
      return response.data as Map<String, dynamic>;
    }
    throw ServerException('Request failed with status: ${response.statusCode}');
  }

  Exception _mapDioException(DioException e) {
    log('DioException caught: ${e.type}, message: ${e.message}');
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => const NetworkException(
        'Connection timeout',
      ),
      DioExceptionType.connectionError => const NetworkException(
        'No internet connection',
      ),
      DioExceptionType.badResponse => ServerException(
        _mapStatusCodeError(e.response?.statusCode),
      ),
      _ => ServerException(e.message ?? 'Unknown error occurred'),
    };
  }

  String _mapStatusCodeError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict';
      case 500:
        return 'Internal server error';
      default:
        return 'Request failed with status: $statusCode';
    }
  }
}

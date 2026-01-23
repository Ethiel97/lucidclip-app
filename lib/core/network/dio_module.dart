import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/network/network.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(DioAuthInterceptor authInterceptor) {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        validateStatus: (status) {
          return status != null && (status >= 200 && status <= 401);
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

    dio.interceptors.addAll([
      authInterceptor, // Add auth interceptor first
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}

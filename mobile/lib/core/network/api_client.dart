import 'package:dio/dio.dart';

import '../config/api_config.dart';

/// Общий HTTP-клиент для запросов к бэкенду.
/// Добавляет baseUrl из конфига и при необходимости — JWT в заголовки.
class ApiClient {
  ApiClient({String? token}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  late final Dio _dio;

  Dio get dio => _dio;

  /// Создать клиент с обновлённым токеном (например после логина)
  ApiClient withToken(String? token) => ApiClient(token: token);
}

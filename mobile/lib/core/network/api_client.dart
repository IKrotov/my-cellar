import 'package:dio/dio.dart';

import '../config/api_config.dart';

/// Колбэк для обновления токена при 401. Возвращает новый access token или null.
typedef OnRefreshRequest = Future<String?> Function();

/// Общий HTTP-клиент для запросов к бэкенду.
/// Добавляет baseUrl из конфига и JWT в заголовки. При 401 вызывает [onRefreshRequest] и повторяет запрос.
class ApiClient {
  ApiClient({
    String? token,
    this.onRefreshRequest,
  }) {
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
    if (onRefreshRequest != null) {
      _dio.interceptors.insert(
        0,
        _RefreshTokenInterceptor(onRefreshRequest!, _dio),
      );
    }
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  final OnRefreshRequest? onRefreshRequest;
  late final Dio _dio;

  Dio get dio => _dio;

  /// Создать клиент с обновлённым токеном (например после логина)
  ApiClient withToken(String? token) => ApiClient(token: token, onRefreshRequest: onRefreshRequest);
}

class _RefreshTokenInterceptor extends QueuedInterceptor {
  _RefreshTokenInterceptor(this._onRefresh, this._dio);

  final OnRefreshRequest _onRefresh;
  final Dio _dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
    _refreshAndRetry(err, handler);
  }

  Future<void> _refreshAndRetry(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final newToken = await _onRefresh();
      if (newToken == null || newToken.isEmpty) {
        return handler.next(err);
      }
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newToken';
      _dio.options.headers['Authorization'] = 'Bearer $newToken';
      final response = await _dio.fetch(opts);
      return handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }
}

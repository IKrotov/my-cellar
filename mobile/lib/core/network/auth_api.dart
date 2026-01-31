import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_client.dart';
import 'dto/auth_dto.dart';

/// API авторизации: логин и регистрация.
class AuthApi {
  AuthApi({ApiClient? apiClient})
      : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  /// POST /auth/login
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return LoginResponseDto.fromJson(response.data!);
  }

  /// POST /auth/register
  Future<RegisterResponseDto> register(RegisterRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return RegisterResponseDto.fromJson(response.data!);
  }

  /// POST /auth/refresh — вызывается без Bearer (клиент без токена).
  Future<RefreshResponseDto> refresh(RefreshRequestDto request) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return RefreshResponseDto.fromJson(response.data!);
  }

  void _throwIfNotOk(Response<Map<String, dynamic>> response) {
    if (response.statusCode != null && response.statusCode! >= 400) {
      final data = response.data;
      final msg = data?['message'] ?? data?['error'] ?? response.statusMessage;
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: msg is String ? msg : 'Ошибка запроса',
      );
    }
  }
}

/// Сообщение для пользователя из ошибки (сеть, 4xx/5xx, прочее).
String messageFromAuthError(Object e) {
  if (e is DioException) {
    final msg = e.response?.data;
    if (msg is Map) {
      if (msg['message'] != null) return msg['message'] as String;
      if (msg['error'] != null) return msg['error'] as String;
    }
    return e.message ?? 'Ошибка сети. Проверьте подключение и URL в ApiConfig.';
  }
  return e.toString();
}

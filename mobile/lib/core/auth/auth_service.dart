import 'dart:async';

import '../network/auth_api.dart';
import '../network/dto/auth_dto.dart';
import 'auth_state.dart';

/// Сервис для управления состоянием аутентификации и вызовов API.
class AuthService {
  AuthService({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  final AuthApi _authApi;
  AuthState _currentState = const AuthLoadingState();

  final _stateController = StreamController<AuthState>.broadcast();

  AuthState get currentState => _currentState;
  Stream<AuthState> get stateStream => _stateController.stream;

  /// Инициализация — проверка сохранённого токена при запуске.
  Future<void> initialize() async {
    // TODO: Прочитать токен из SecureStorage и проверить валидность (например запросом /me).
    await Future.delayed(const Duration(milliseconds: 300));
    _updateState(const UnauthenticatedState());
  }

  /// Вход пользователя через API.
  Future<void> login(String username, String password) async {
    _updateState(const AuthLoadingState());

    try {
      final response = await _authApi.login(
        LoginRequestDto(login: username, password: password),
      );
      _updateState(AuthenticatedState(
        token: response.token,
        userId: response.login,
        username: response.login,
      ));
    } on Exception catch (e) {
      _updateState(const UnauthenticatedState());
      rethrow;
    }
  }

  /// Регистрация через API.
  Future<void> register(String username, String password) async {
    _updateState(const AuthLoadingState());

    try {
      final response = await _authApi.register(
        RegisterRequestDto(login: username, password: password),
      );
      _updateState(AuthenticatedState(
        token: response.token,
        userId: response.login,
        username: response.login,
      ));
    } on Exception catch (e) {
      _updateState(const UnauthenticatedState());
      rethrow;
    }
  }

  /// Выход.
  Future<void> logout() async {
    _updateState(const UnauthenticatedState());
  }

  void _updateState(AuthState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _stateController.close();
  }
}

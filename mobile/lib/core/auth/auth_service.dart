import 'dart:async';

import '../network/api_client.dart';
import '../network/auth_api.dart';
import '../network/dto/auth_dto.dart';
import '../storage/token_storage.dart';
import 'auth_state.dart';

/// Сервис для управления состоянием аутентификации и вызовов API.
class AuthService {
  AuthService({AuthApi? authApi, TokenStorage? tokenStorage})
      : _authApi = authApi ?? AuthApi(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;
  AuthState _currentState = const AuthLoadingState();

  final _stateController = StreamController<AuthState>.broadcast();

  AuthState get currentState => _currentState;
  Stream<AuthState> get stateStream => _stateController.stream;

  /// Инициализация — чтение сохранённого токена при запуске.
  Future<void> initialize() async {
    final stored = await _tokenStorage.read();
    if (stored.accessToken != null &&
        stored.accessToken!.isNotEmpty &&
        stored.username != null &&
        stored.username!.isNotEmpty) {
      _updateState(AuthenticatedState(
        token: stored.accessToken!,
        userId: stored.username!,
        username: stored.username!,
      ));
    } else {
      _updateState(const UnauthenticatedState());
    }
  }

  /// Вход пользователя через API.
  Future<void> login(String username, String password) async {
    _updateState(const AuthLoadingState());

    try {
      final response = await _authApi.login(
        LoginRequestDto(login: username, password: password),
      );
      await _tokenStorage.save(
        response.accessToken,
        response.refreshToken,
        response.login,
      );
      _updateState(AuthenticatedState(
        token: response.accessToken,
        userId: response.login,
        username: response.login,
      ));
    } on Exception catch (_) {
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
      await _tokenStorage.save(
        response.accessToken,
        response.refreshToken,
        response.login,
      );
      _updateState(AuthenticatedState(
        token: response.accessToken,
        userId: response.login,
        username: response.login,
      ));
    } on Exception catch (_) {
      _updateState(const UnauthenticatedState());
      rethrow;
    }
  }

  /// Выход.
  Future<void> logout() async {
    await _tokenStorage.clear();
    _updateState(const UnauthenticatedState());
  }

  /// Клиент для авторизованных запросов. При 401 автоматически вызывает refresh и повторяет запрос.
  ApiClient getApiClient() {
    return ApiClient(
      token: _currentState is AuthenticatedState
          ? (_currentState as AuthenticatedState).token
          : null,
      onRefreshRequest: _performRefresh,
    );
  }

  /// Обновление пары токенов по refresh token. Вызывается интерцептором при 401.
  Future<String?> _performRefresh() async {
    final stored = await _tokenStorage.read();
    if (stored.refreshToken == null || stored.refreshToken!.isEmpty) {
      return null;
    }
    try {
      final response = await _authApi.refresh(
        RefreshRequestDto(refreshToken: stored.refreshToken!),
      );
      await _tokenStorage.save(
        response.accessToken,
        response.refreshToken,
        stored.username ?? '',
      );
      if (_currentState is AuthenticatedState) {
        _updateState(AuthenticatedState(
          token: response.accessToken,
          userId: (_currentState as AuthenticatedState).userId,
          username: (_currentState as AuthenticatedState).username,
        ));
      }
      return response.accessToken;
    } catch (_) {
      return null;
    }
  }

  void _updateState(AuthState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _stateController.close();
  }
}

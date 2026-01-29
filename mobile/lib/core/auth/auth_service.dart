import 'dart:async';
import 'auth_state.dart';

/// Сервис для управления состоянием аутентификации
class AuthService {
  AuthState _currentState = const AuthLoadingState();
  
  // Stream для отслеживания изменений состояния
  final _stateController = StreamController<AuthState>.broadcast();
  
  /// Текущее состояние
  AuthState get currentState => _currentState;
  
  /// Stream изменений состояния
  Stream<AuthState> get stateStream => _stateController.stream;
  
  /// Инициализация - проверка сохраненного токена при запуске
  Future<void> initialize() async {
    // TODO: Проверить наличие токена в SecureStorage
    // Пока что просто переходим в unauthenticated
    await Future.delayed(const Duration(seconds: 1)); // Симуляция проверки
    
    _updateState(const UnauthenticatedState());
  }
  
  /// Вход пользователя
  Future<void> login(String username, String password) async {
    _updateState(const AuthLoadingState());
    
    try {
      // Моковый API - симуляция задержки сети
      await Future.delayed(const Duration(seconds: 1));
      
      // Проверка моковых учетных данных
      if (username == 'admin' && password == '123') {
        // TODO: Сохранить токен в SecureStorage
        const mockToken = 'mock_jwt_token_12345';
        const mockUserId = '1';
        
        _updateState(AuthenticatedState(
          token: mockToken,
          userId: mockUserId,
          username: username,
        ));
      } else {
        throw Exception('Неверный логин или пароль');
      }
    } catch (e) {
      // В случае ошибки возвращаемся в unauthenticated
      _updateState(const UnauthenticatedState());
      rethrow;
    }
  }
  
  /// Регистрация нового пользователя
  Future<void> register(String username, String password) async {
    _updateState(const AuthLoadingState());
    
    try {
      // Моковый API - симуляция задержки сети
      await Future.delayed(const Duration(seconds: 1));
      
      // Валидация данных
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Логин и пароль не могут быть пустыми');
      }
      
      if (username == 'admin') {
        throw Exception('Пользователь с таким логином уже существует');
      }
      
      if (password.length < 3) {
        throw Exception('Пароль должен содержать минимум 3 символа');
      }
      
      // Моковая успешная регистрация - автоматически логиним пользователя
      const mockToken = 'mock_jwt_token_123';
      const mockUserId = '2';
      
      _updateState(AuthenticatedState(
        token: mockToken,
        userId: mockUserId,
        username: username,
      ));
    } catch (e) {
      // В случае ошибки возвращаемся в unauthenticated
      _updateState(const UnauthenticatedState());
      rethrow;
    }
  }
  
  /// Выход пользователя
  Future<void> logout() async {
    // TODO: Удалить токен из SecureStorage
    _updateState(const UnauthenticatedState());
  }
  
  /// Обновление состояния и уведомление слушателей
  void _updateState(AuthState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
  
  /// Освобождение ресурсов
  void dispose() {
    _stateController.close();
  }
}

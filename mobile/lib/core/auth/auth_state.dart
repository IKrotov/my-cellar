/// Состояние аутентификации пользователя
sealed class AuthState {
  const AuthState();
}

/// Пользователь не аутентифицирован - показываем экран логина
class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

/// Идет проверка токена при запуске приложения
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// Пользователь аутентифицирован - показываем основной экран
class AuthenticatedState extends AuthState {
  final String token;
  final String userId;
  final String username;

  const AuthenticatedState({
    required this.token,
    required this.userId,
    required this.username,
  });
}

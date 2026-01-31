/// Запрос логина (совпадает с бэкендом: login, password)
class LoginRequestDto {
  final String login;
  final String password;

  const LoginRequestDto({required this.login, required this.password});

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };
}

/// Ответ логина (accessToken + refreshToken)
class LoginResponseDto {
  final String login;
  final String accessToken;
  final String refreshToken;

  LoginResponseDto({
    required this.login,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      login: json['login'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

/// Запрос регистрации
class RegisterRequestDto {
  final String login;
  final String password;

  const RegisterRequestDto({required this.login, required this.password});

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };
}

/// Ответ регистрации (accessToken + refreshToken)
class RegisterResponseDto {
  final String login;
  final String accessToken;
  final String refreshToken;

  RegisterResponseDto({
    required this.login,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      login: json['login'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

/// Запрос обновления токена
class RefreshRequestDto {
  final String refreshToken;

  const RefreshRequestDto({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

/// Ответ обновления токена
class RefreshResponseDto {
  final String accessToken;
  final String refreshToken;

  RefreshResponseDto({required this.accessToken, required this.refreshToken});

  factory RefreshResponseDto.fromJson(Map<String, dynamic> json) {
    return RefreshResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

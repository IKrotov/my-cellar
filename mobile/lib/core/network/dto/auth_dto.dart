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

/// Ответ логина
class LoginResponseDto {
  final String login;
  final String token;

  LoginResponseDto({required this.login, required this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      login: json['login'] as String,
      token: json['token'] as String,
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

/// Ответ регистрации
class RegisterResponseDto {
  final String login;
  final String token;

  RegisterResponseDto({required this.login, required this.token});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      login: json['login'] as String,
      token: json['token'] as String,
    );
  }
}

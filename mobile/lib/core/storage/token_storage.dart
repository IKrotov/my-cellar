import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Сохранение и чтение токена и логина из безопасного хранилища (Keychain / Keystore).
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'auth_access_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyUsername = 'auth_username';

  /// Сохранить данные после успешного логина/регистрации или рефреша.
  Future<void> save(String accessToken, String refreshToken, String username) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUsername, value: username);
  }

  /// Прочитать сохранённые токены и логин. Если чего-то нет — null.
  Future<({String? accessToken, String? refreshToken, String? username})> read() async {
    final accessToken = await _storage.read(key: _keyAccessToken);
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    final username = await _storage.read(key: _keyUsername);
    return (accessToken: accessToken, refreshToken: refreshToken, username: username);
  }

  /// Очистить при выходе.
  Future<void> clear() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUsername);
  }
}

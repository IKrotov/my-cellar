import 'package:flutter/foundation.dart';

/// Конфигурация API: хост и базовый URL бэкенда.
///
/// В debug-сборке можно использовать локальный адрес (эмулятор Android:
/// 10.0.2.2:8080, iOS-симулятор: localhost:8080).
/// В release подставь свой URL с Render/другого хостинга.
class ApiConfig {
  ApiConfig._();

  /// Базовый URL API без завершающего слеша, например:
  /// - Production: https://my-cellar-production.up.railway.app
  /// - Локально (Android emulator): http://10.0.2.2:8080
  /// - Локально (iOS simulator): http://localhost:8080
  static String get baseUrl {
    if (kDebugMode && _useLocalBaseUrl) {
      return _localBaseUrl;
    }
    return _productionBaseUrl;
  }

  /// Production URL — замени на свой после деплоя
  static const String _productionBaseUrl =
      'https://my-cellar-production.up.railway.app';

  /// Локальный URL для разработки (без порта в конце, если 80/443)
  static const String _localBaseUrl = 'http://10.0.2.2:8080';

  /// В true — в debug-сборке используется _localBaseUrl
  static const bool _useLocalBaseUrl = false;

  /// Префикс API (добавляется к baseUrl при запросах)
  static const String apiPrefix = '/api/v1';
}

import 'package:shared_preferences/shared_preferences.dart';

/// Сохранение и чтение выбранной локали (код языка).
class LocaleStorage {
  LocaleStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  static const _keyLocale = 'app_locale';

  Future<SharedPreferences> get _storage async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Сохранить код языка (ru, en, es, de).
  Future<void> saveLocale(String languageCode) async {
    final prefs = await _storage;
    await prefs.setString(_keyLocale, languageCode);
  }

  /// Прочитать сохранённый код языка или null.
  Future<String?> getLocale() async {
    final prefs = await _storage;
    return prefs.getString(_keyLocale);
  }
}

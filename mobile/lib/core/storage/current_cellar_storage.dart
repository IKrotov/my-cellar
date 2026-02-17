import 'package:shared_preferences/shared_preferences.dart';

/// Текущий выбранный погреб (id + name) для отображения и запросов к API.
class CurrentCellar {
  final int id;
  final String name;

  const CurrentCellar({required this.id, required this.name});
}

/// Сохранение и чтение текущего погреба в SharedPreferences.
class CurrentCellarStorage {
  CurrentCellarStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  static const _keyCellarId = 'current_cellar_id';
  static const _keyCellarName = 'current_cellar_name';

  Future<SharedPreferences> get _storage async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Сохранить текущий погреб.
  Future<void> save(CurrentCellar cellar) async {
    final prefs = await _storage;
    await prefs.setInt(_keyCellarId, cellar.id);
    await prefs.setString(_keyCellarName, cellar.name);
  }

  /// Прочитать текущий погреб или null.
  Future<CurrentCellar?> read() async {
    final prefs = await _storage;
    final id = prefs.getInt(_keyCellarId);
    final name = prefs.getString(_keyCellarName);
    if (id == null || name == null) return null;
    return CurrentCellar(id: id, name: name);
  }

  /// Очистить (например при выходе).
  Future<void> clear() async {
    final prefs = await _storage;
    await prefs.remove(_keyCellarId);
    await prefs.remove(_keyCellarName);
  }
}

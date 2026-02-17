import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite-база приложения: таблицы cellars и ingredients (с полями для будущей синхронизации).
class AppDatabase {
  static const _dbName = 'my_cellar.db';
  static const _dbVersion = 1;

  static Database? _db;
  static Future<Database>? _initFuture;

  /// Открывает БД (один раз). Путь: [getDatabasesPath]/my_cellar.db.
  static Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _initFuture ??= _open();
    _db = await _initFuture!;
    return _db!;
  }

  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cellars (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER UNIQUE,
        name TEXT NOT NULL,
        sync_status TEXT NOT NULL DEFAULT 'synced',
        updated_at INTEGER
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_cellars_server_id ON cellars(server_id)
    ''');
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER UNIQUE,
        cellar_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'NONE',
        amount INTEGER,
        sync_status TEXT NOT NULL DEFAULT 'synced',
        updated_at INTEGER
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_ingredients_cellar_id ON ingredients(cellar_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_ingredients_server_id ON ingredients(server_id)
    ''');
  }

  /// Очистить все данные (погреба и ингредиенты). Вызывать при выходе пользователя.
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('ingredients');
    await db.delete('cellars');
  }

  /// Закрыть БД (например при выходе). После этого следующий [database] откроет заново.
  static Future<void> close() async {
    final db = _db;
    _db = null;
    _initFuture = null;
    if (db != null && db.isOpen) await db.close();
  }
}

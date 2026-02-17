import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/entities/cellar_entity.dart';
import '../network/dto/cellar_dto.dart';

/// Репозиторий погребов: чтение и запись в локальную SQLite.
class CellarRepository {
  CellarRepository({Future<Database> Function()? getDb}) : _getDb = getDb ?? _defaultDb;

  static Future<Database> _defaultDb() => AppDatabase.database;

  final Future<Database> Function() _getDb;

  /// Все погреба, по имени.
  Future<List<CellarEntity>> getAll() async {
    final db = await _getDb();
    final list = await db.query(
      CellarEntity.tableName,
      orderBy: '${CellarEntity.columnName} ASC',
    );
    return list.map((m) => CellarEntity.fromMap(m)).toList();
  }

  /// По server_id (id с бэкенда).
  Future<CellarEntity?> getByServerId(int serverId) async {
    final db = await _getDb();
    final list = await db.query(
      CellarEntity.tableName,
      where: '${CellarEntity.columnServerId} = ?',
      whereArgs: [serverId],
    );
    if (list.isEmpty) return null;
    return CellarEntity.fromMap(list.first);
  }

  /// По локальному id.
  Future<CellarEntity?> getById(int id) async {
    final db = await _getDb();
    final list = await db.query(
      CellarEntity.tableName,
      where: '${CellarEntity.columnId} = ?',
      whereArgs: [id],
    );
    if (list.isEmpty) return null;
    return CellarEntity.fromMap(list.first);
  }

  /// Вставить погреб (id не передаём — автоинкремент). Возвращает вставленный id.
  Future<int> insert({
    int? serverId,
    required String name,
    String syncStatus = 'synced',
    int? updatedAt,
  }) async {
    final db = await _getDb();
    final map = <String, Object?>{
      CellarEntity.columnServerId: serverId,
      CellarEntity.columnName: name,
      CellarEntity.columnSyncStatus: syncStatus,
      CellarEntity.columnUpdatedAt: updatedAt,
    };
    return db.insert(CellarEntity.tableName, map);
  }

  /// Обновить по локальному id.
  Future<int> update(int id, {int? serverId, String? name, String? syncStatus, int? updatedAt}) async {
    final db = await _getDb();
    final map = <String, Object?>{};
    if (serverId != null) map[CellarEntity.columnServerId] = serverId;
    if (name != null) map[CellarEntity.columnName] = name;
    if (syncStatus != null) map[CellarEntity.columnSyncStatus] = syncStatus;
    if (updatedAt != null) map[CellarEntity.columnUpdatedAt] = updatedAt;
    if (map.isEmpty) return 0;
    return db.update(
      CellarEntity.tableName,
      map,
      where: '${CellarEntity.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Удалить по локальному id.
  Future<int> deleteById(int id) async {
    final db = await _getDb();
    return db.delete(
      CellarEntity.tableName,
      where: '${CellarEntity.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Удалить по server_id.
  Future<int> deleteByServerId(int serverId) async {
    final db = await _getDb();
    return db.delete(
      CellarEntity.tableName,
      where: '${CellarEntity.columnServerId} = ?',
      whereArgs: [serverId],
    );
  }

  /// Вставить или обновить по server_id (для синка с бэкенда).
  /// Обновляет локальную запись только если у бэка [updatedAt] новее локального (или локального нет / нет timestamp).
  Future<void> upsertByServerId(int serverId, String name, {int? updatedAt}) async {
    final existing = await getByServerId(serverId);
    if (existing != null) {
      final localTs = existing.updatedAt;
      if (localTs != null && updatedAt != null && updatedAt <= localTs) return;
      await update(existing.id, name: name, syncStatus: 'synced', updatedAt: updatedAt);
    } else {
      await insert(serverId: serverId, name: name, syncStatus: 'synced', updatedAt: updatedAt);
    }
  }

  /// Синхронизация из ответа API: для каждой записи с id вызывается [upsertByServerId] (с учётом updated_at).
  Future<void> syncFromBackend(List<CellarResponseDto> list) async {
    for (final item in list) {
      final serverId = item.id;
      if (serverId == null) continue;
      await upsertByServerId(serverId, item.name, updatedAt: item.updatedAt);
    }
  }

  /// Список записей со статусом pending (ещё не синхронизированы).
  Future<List<CellarEntity>> getPendingSync() async {
    final db = await _getDb();
    final list = await db.query(
      CellarEntity.tableName,
      where: '${CellarEntity.columnSyncStatus} = ?',
      whereArgs: ['pending'],
    );
    return list.map((m) => CellarEntity.fromMap(m)).toList();
  }
}

import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/entities/ingredient_entity.dart';
import '../network/dto/ingredient_dto.dart';

/// Репозиторий ингредиентов: чтение и запись в локальную SQLite.
/// [cellarId] в методах — это server_id погреба.
class IngredientRepository {
  IngredientRepository({Future<Database> Function()? getDb}) : _getDb = getDb ?? _defaultDb;

  static Future<Database> _defaultDb() => AppDatabase.database;

  final Future<Database> Function() _getDb;

  /// Все ингредиенты погреба (по server_id погреба).
  Future<List<IngredientEntity>> getByCellarId(int cellarServerId) async {
    final db = await _getDb();
    final list = await db.query(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnCellarId} = ?',
      whereArgs: [cellarServerId],
      orderBy: '${IngredientEntity.columnName} ASC',
    );
    return list.map((m) => IngredientEntity.fromMap(m)).toList();
  }

  /// По server_id ингредиента.
  Future<IngredientEntity?> getByServerId(int serverId) async {
    final db = await _getDb();
    final list = await db.query(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnServerId} = ?',
      whereArgs: [serverId],
    );
    if (list.isEmpty) return null;
    return IngredientEntity.fromMap(list.first);
  }

  /// По локальному id.
  Future<IngredientEntity?> getById(int id) async {
    final db = await _getDb();
    final list = await db.query(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnId} = ?',
      whereArgs: [id],
    );
    if (list.isEmpty) return null;
    return IngredientEntity.fromMap(list.first);
  }

  /// Вставить ингредиент. [cellarId] — server_id погреба. Возвращает локальный id.
  Future<int> insert({
    int? serverId,
    required int cellarId,
    required String name,
    required String type,
    String status = 'NONE',
    int? amount,
    String syncStatus = 'synced',
    int? updatedAt,
  }) async {
    final db = await _getDb();
    final map = <String, Object?>{
      IngredientEntity.columnServerId: serverId,
      IngredientEntity.columnCellarId: cellarId,
      IngredientEntity.columnName: name,
      IngredientEntity.columnType: type,
      IngredientEntity.columnStatus: status,
      IngredientEntity.columnAmount: amount,
      IngredientEntity.columnSyncStatus: syncStatus,
      IngredientEntity.columnUpdatedAt: updatedAt,
    };
    return db.insert(IngredientEntity.tableName, map);
  }

  /// Обновить по локальному id.
  Future<int> update(
    int id, {
    int? serverId,
    int? cellarId,
    String? name,
    String? type,
    String? status,
    int? amount,
    String? syncStatus,
    int? updatedAt,
  }) async {
    final db = await _getDb();
    final map = <String, Object?>{};
    if (serverId != null) map[IngredientEntity.columnServerId] = serverId;
    if (cellarId != null) map[IngredientEntity.columnCellarId] = cellarId;
    if (name != null) map[IngredientEntity.columnName] = name;
    if (type != null) map[IngredientEntity.columnType] = type;
    if (status != null) map[IngredientEntity.columnStatus] = status;
    if (amount != null) map[IngredientEntity.columnAmount] = amount;
    if (syncStatus != null) map[IngredientEntity.columnSyncStatus] = syncStatus;
    if (updatedAt != null) map[IngredientEntity.columnUpdatedAt] = updatedAt;
    if (map.isEmpty) return 0;
    return db.update(
      IngredientEntity.tableName,
      map,
      where: '${IngredientEntity.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Удалить по локальному id.
  Future<int> deleteById(int id) async {
    final db = await _getDb();
    return db.delete(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Удалить по server_id.
  Future<int> deleteByServerId(int serverId) async {
    final db = await _getDb();
    return db.delete(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnServerId} = ?',
      whereArgs: [serverId],
    );
  }

  /// Вставить или обновить по server_id (для синка с бэкенда).
  /// Обновляет локальную запись только если у бэка [updatedAt] новее локального (или локального нет).
  Future<void> upsertByServerId({
    required int serverId,
    required int cellarId,
    required String name,
    required String type,
    String status = 'NONE',
    int? amount,
    int? updatedAt,
  }) async {
    final existing = await getByServerId(serverId);
    if (existing != null) {
      final localTs = existing.updatedAt;
      if (localTs != null && updatedAt != null && updatedAt <= localTs) return;
      await update(
        existing.id,
        name: name,
        type: type,
        status: status,
        amount: amount,
        syncStatus: 'synced',
        updatedAt: updatedAt,
      );
    } else {
      await insert(
        serverId: serverId,
        cellarId: cellarId,
        name: name,
        type: type,
        status: status,
        amount: amount,
        syncStatus: 'synced',
        updatedAt: updatedAt,
      );
    }
  }

  /// Синхронизация из ответа API по погребу [cellarServerId].
  Future<void> syncFromBackend(List<IngredientResponseDto> list, int cellarServerId) async {
    for (final item in list) {
      final serverId = item.id;
      if (serverId == null) continue;
      await upsertByServerId(
        serverId: serverId,
        cellarId: cellarServerId,
        name: item.name,
        type: item.type,
        status: item.status ?? 'NONE',
        amount: item.amount,
        updatedAt: item.updatedAt,
      );
    }
  }

  /// Ингредиенты со статусом pending.
  Future<List<IngredientEntity>> getPendingSync() async {
    final db = await _getDb();
    final list = await db.query(
      IngredientEntity.tableName,
      where: '${IngredientEntity.columnSyncStatus} = ?',
      whereArgs: ['pending'],
    );
    return list.map((m) => IngredientEntity.fromMap(m)).toList();
  }
}

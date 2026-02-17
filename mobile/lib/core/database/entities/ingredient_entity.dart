/// Строка таблицы ingredients в SQLite.
class IngredientEntity {
  final int id;
  final int? serverId;
  final int cellarId;
  final String name;
  final String type;
  final String status;
  final int? amount;
  final String syncStatus;
  final int? updatedAt;

  const IngredientEntity({
    required this.id,
    this.serverId,
    required this.cellarId,
    required this.name,
    required this.type,
    this.status = 'NONE',
    this.amount,
    this.syncStatus = 'synced',
    this.updatedAt,
  });

  static const tableName = 'ingredients';
  static const columnId = 'id';
  static const columnServerId = 'server_id';
  static const columnCellarId = 'cellar_id';
  static const columnName = 'name';
  static const columnType = 'type';
  static const columnStatus = 'status';
  static const columnAmount = 'amount';
  static const columnSyncStatus = 'sync_status';
  static const columnUpdatedAt = 'updated_at';

  Map<String, Object?> toMap() => {
        columnId: id,
        columnServerId: serverId,
        columnCellarId: cellarId,
        columnName: name,
        columnType: type,
        columnStatus: status,
        columnAmount: amount,
        columnSyncStatus: syncStatus,
        columnUpdatedAt: updatedAt,
      };

  static IngredientEntity fromMap(Map<String, Object?> map) {
    return IngredientEntity(
      id: map[columnId] as int,
      serverId: map[columnServerId] as int?,
      cellarId: map[columnCellarId] as int,
      name: map[columnName] as String,
      type: map[columnType] as String,
      status: map[columnStatus] as String? ?? 'NONE',
      amount: map[columnAmount] as int?,
      syncStatus: map[columnSyncStatus] as String? ?? 'synced',
      updatedAt: map[columnUpdatedAt] as int?,
    );
  }

  IngredientEntity copyWith({
    int? id,
    int? serverId,
    int? cellarId,
    String? name,
    String? type,
    String? status,
    int? amount,
    String? syncStatus,
    int? updatedAt,
  }) {
    return IngredientEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      cellarId: cellarId ?? this.cellarId,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

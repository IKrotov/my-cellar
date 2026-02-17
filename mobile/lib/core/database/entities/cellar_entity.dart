/// Строка таблицы cellars в SQLite.
class CellarEntity {
  final int id;
  final int? serverId;
  final String name;
  final String syncStatus;
  final int? updatedAt;

  const CellarEntity({
    required this.id,
    this.serverId,
    required this.name,
    this.syncStatus = 'synced',
    this.updatedAt,
  });

  static const tableName = 'cellars';
  static const columnId = 'id';
  static const columnServerId = 'server_id';
  static const columnName = 'name';
  static const columnSyncStatus = 'sync_status';
  static const columnUpdatedAt = 'updated_at';

  Map<String, Object?> toMap() => {
        columnId: id,
        columnServerId: serverId,
        columnName: name,
        columnSyncStatus: syncStatus,
        columnUpdatedAt: updatedAt,
      };

  static CellarEntity fromMap(Map<String, Object?> map) {
    return CellarEntity(
      id: map[columnId] as int,
      serverId: map[columnServerId] as int?,
      name: map[columnName] as String,
      syncStatus: map[columnSyncStatus] as String? ?? 'synced',
      updatedAt: map[columnUpdatedAt] as int?,
    );
  }

  CellarEntity copyWith({
    int? id,
    int? serverId,
    String? name,
    String? syncStatus,
    int? updatedAt,
  }) {
    return CellarEntity(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

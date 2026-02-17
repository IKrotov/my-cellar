/// Ответ бэкенда: один погреб.
/// [updatedAt] — timestamp (мс) последнего обновления на бэке; для merge в локальную БД (обновляем только если новее).
/// Бэкенд отдаёт Instant как ISO-8601 строку (например "2025-01-31T14:30:00.123Z"); парсим в мс.
class CellarResponseDto {
  final int? id;
  final String name;
  final int? updatedAt;

  const CellarResponseDto({this.id, required this.name, this.updatedAt});

  factory CellarResponseDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final idInt = id is int ? id : (id as num?)?.toInt();
    final updatedAt = _parseUpdatedAt(json['updatedAt']);
    return CellarResponseDto(
      id: idInt,
      name: json['name'] as String? ?? '',
      updatedAt: updatedAt,
    );
  }

  static int? _parseUpdatedAt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final dt = DateTime.tryParse(value);
      return dt?.millisecondsSinceEpoch;
    }
    return null;
  }
}

/// Запрос создания погреба (тело: { "name": "..." }).
class CreateCellarRequestDto {
  final String name;

  const CreateCellarRequestDto({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

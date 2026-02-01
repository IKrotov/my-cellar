import 'package:dio/dio.dart';

/// Запрос создания ингредиента (совпадает с бэкендом).
class CreateIngredientRequestDto {
  final String name;
  final String type; // UNKNOWN, SPICE, MEAT, VEGETABLE, FRUIT
  final String status; // NONE, FEW, MEDIUM, HIGH
  final int? amount;

  const CreateIngredientRequestDto({
    required this.name,
    required this.type,
    required this.status,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'status': status,
        if (amount != null) 'amount': amount,
      };
}

/// Запрос обновления ингредиента (совпадает с бэкендом).
class UpdateIngredientRequestDto {
  final String name;
  final String type;
  final String status;
  final int? amount;

  const UpdateIngredientRequestDto({
    required this.name,
    required this.type,
    required this.status,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'status': status,
        if (amount != null) 'amount': amount,
      };
}

/// Ответ бэкенда по ингредиенту.
class IngredientResponseDto {
  final int? id;
  final String name;
  final String type;
  final String? status;
  final int? amount;

  IngredientResponseDto({
    this.id,
    required this.name,
    required this.type,
    this.status,
    this.amount,
  });

  factory IngredientResponseDto.fromJson(Map<String, dynamic> json) {
    return IngredientResponseDto(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String?,
      amount: json['amount'] as int?,
    );
  }
}

/// Сообщение об ошибке из ответа API.
String messageFromIngredientError(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'] as String;
    }
    if (data is Map && data['error'] != null) {
      return data['error'] as String;
    }
    return e.message ?? 'Ошибка сети';
  }
  return e.toString();
}

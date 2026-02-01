import 'package:dio/dio.dart';

import 'dto/ingredient_dto.dart';

/// API ингредиентов: список и создание.
class IngredientsApi {
  IngredientsApi(Dio dio) : _dio = dio;

  final Dio _dio;

  /// GET /ingredients — список ингредиентов пользователя.
  Future<List<IngredientResponseDto>> getList() async {
    final response = await _dio.get<List<dynamic>>('/ingredients');
    _throwIfNotOk(response);
    final list = response.data;
    if (list == null) return [];
    return list
        .map((e) => IngredientResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /ingredients — создать ингредиент.
  Future<IngredientResponseDto> create(CreateIngredientRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/ingredients',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return IngredientResponseDto.fromJson(response.data!);
  }

  /// PUT /ingredients/{id} — обновить ингредиент.
  Future<IngredientResponseDto> update(int id, UpdateIngredientRequestDto request) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/ingredients/$id',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return IngredientResponseDto.fromJson(response.data!);
  }

  /// DELETE /ingredients/{id} — удалить ингредиент.
  Future<void> delete(int id) async {
    final response = await _dio.delete('/ingredients/$id');
    _throwIfNotOk(response);
  }

  void _throwIfNotOk(Response response) {
    if (response.statusCode != null && response.statusCode! >= 400) {
      final data = response.data;
      final msg = data is Map
          ? (data['message'] ?? data['error'] ?? response.statusMessage)
          : response.statusMessage;
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: msg is String ? msg : 'Ошибка запроса',
      );
    }
  }
}

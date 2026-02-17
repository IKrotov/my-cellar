import 'package:dio/dio.dart';

import 'dto/ingredient_dto.dart';

/// API ингредиентов в рамках погреба: /cellars/{cellarId}/ingredients.
class IngredientsApi {
  IngredientsApi(Dio dio) : _dio = dio;

  final Dio _dio;

  /// GET /cellars/{cellarId}/ingredients — список ингредиентов погреба.
  Future<List<IngredientResponseDto>> getList(int cellarId) async {
    final response = await _dio.get<List<dynamic>>('/cellars/$cellarId/ingredients');
    _throwIfNotOk(response);
    final list = response.data;
    if (list == null) return [];
    return list
        .map((e) => IngredientResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /cellars/{cellarId}/ingredients — создать ингредиент.
  Future<IngredientResponseDto> create(int cellarId, CreateIngredientRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/cellars/$cellarId/ingredients',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return IngredientResponseDto.fromJson(response.data!);
  }

  /// PUT /cellars/{cellarId}/ingredients/{id} — обновить ингредиент.
  Future<IngredientResponseDto> update(int cellarId, int id, UpdateIngredientRequestDto request) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/cellars/$cellarId/ingredients/$id',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return IngredientResponseDto.fromJson(response.data!);
  }

  /// DELETE /cellars/{cellarId}/ingredients/{id} — удалить ингредиент.
  Future<void> delete(int cellarId, int id) async {
    final response = await _dio.delete('/cellars/$cellarId/ingredients/$id');
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

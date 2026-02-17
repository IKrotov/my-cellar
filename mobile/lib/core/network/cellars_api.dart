import 'package:dio/dio.dart';

import 'dto/cellar_dto.dart';

/// API погребов: список и создание.
class CellarsApi {
  CellarsApi(Dio dio) : _dio = dio;

  final Dio _dio;

  /// GET /cellars — список погребов пользователя.
  Future<List<CellarResponseDto>> getList() async {
    final response = await _dio.get<List<dynamic>>('/cellars');
    _throwIfNotOk(response);
    final list = response.data;
    if (list == null) return [];
    return list
        .map((e) => CellarResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /cellars — создать погреб.
  Future<CellarResponseDto> create(CreateCellarRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/cellars',
      data: request.toJson(),
    );
    _throwIfNotOk(response);
    return CellarResponseDto.fromJson(response.data!);
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

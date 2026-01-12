import 'dart:convert';

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:dio/dio.dart';

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

class ApiService {
  final _log = getLogger('ApiService');
  final Dio dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  Future<Map<String, dynamic>> request({
    dynamic body,
    required String url,
    required HttpMethod method,
    bool needAuthenticate = false,
  }) async {
    Map<String, String> headers = {};
    dynamic dataResponse;
    String? errorMessage;

    if (needAuthenticate) {
      final token = await locator<AuthService>().currUser?.getIdToken() ?? "";
      headers["Authorization"] = "Bearer $token";
    }

    try {
      final encodedBody = body != null ? jsonEncode(body) : null;
      Response response;

      switch (method.name) {
        case 'POST':
          response = await dio.post(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case 'GET':
          response = await dio.get(
            url,
            options: Options(headers: headers),
          );
          break;
        case 'PUT':
          response = await dio.put(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case 'DELETE':
          response = await dio.delete(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case 'PATCH':
          response = await dio.patch(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        default:
          throw AppError(message: 'Método HTTP não suportado: $method');
      }

      try {
        // verifica se o corpo está vazio, nulo ou contém apenas espaços
        if (response.data == null ||
            (response.data is String &&
                (response.data as String).trim().isEmpty)) {
          return {};
        }
        final data = jsonDecode(response.data);
        return data;
      } on Exception catch (e) {
        _log.e('Error decoding response data: $e');
        return {};
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        try {
          final responseData = jsonDecode(e.response!.data);
          if (responseData is Map &&
              responseData.containsKey('message') &&
              responseData['message'] is String?) {
            errorMessage = responseData['message'];
          }
        } catch (_) {
          // Se falhar ao decodificar, ignora
        }
      }

      //_log.e('Erro: $e');
      _log.e('errorMessage: $errorMessage');
      throw AppError(
        message: errorMessage ?? 'Erro desconhecido',
        dataResponse: dataResponse,
      );
    } catch (e) {
      _log.e('Erro inesperado: $e');
      throw AppError(
        message: errorMessage ?? 'Erro desconhecido',
        dataResponse: dataResponse,
      );
    }
  }
}

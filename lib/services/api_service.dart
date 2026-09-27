import 'dart:convert';

import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/utils/app_session.dart';
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
  late final Dio dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        // O backend loga estes cabeçalhos (request-logger do api_bootstrap): é o que
        // cruza o log do app com o dele. OBRIGATÓRIO: não remover.
        onRequest: (options, handler) {
          options.headers['x-session-id'] = AppSession.id;
          options.headers['x-app-version'] = AppSession.version;
          options.headers['x-platform'] = AppSession.platform;
          options.extra['startedAt'] = DateTime.now();
          _log.i('→ ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _log.i('← ${response.requestOptions.method} '
              '${response.requestOptions.path} ${response.statusCode} '
              '${_elapsed(response.requestOptions)} '
              'requestId ${response.headers.value('x-request-id')}');
          handler.next(response);
        },
        onError: (error, handler) {
          _log.e('✕ ${error.requestOptions.method} '
              '${error.requestOptions.path} ${error.response?.statusCode} '
              '${_elapsed(error.requestOptions)} ${error.type.name} '
              'requestId ${error.response?.headers.value('x-request-id')} '
              'resposta ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

  static String _elapsed(RequestOptions options) {
    final startedAt = options.extra['startedAt'];
    return startedAt is DateTime
        ? '${DateTime.now().difference(startedAt).inMilliseconds}ms'
        : '';
  }
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

      switch (method) {
        case HttpMethod.POST:
          response = await dio.post(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case HttpMethod.GET:
          response = await dio.get(
            url,
            options: Options(headers: headers),
          );
          break;
        case HttpMethod.PUT:
          response = await dio.put(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
          break;
        case HttpMethod.PATCH:
          response = await dio.patch(
            url,
            data: encodedBody,
            options: Options(headers: headers),
          );
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
      int? statusCode;
      String? statusMessage;
      if (e.response != null && e.response!.data != null) {
        statusCode = e.response!.statusCode;
        statusMessage = e.response!.statusMessage;
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
      _log.e(
          'errorMessage: $errorMessage\nstatusCode: $statusCode\nstatusMessage: $statusMessage\nurl: $url');
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

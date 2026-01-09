import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/errors/exceptions.dart';

class ApiClient {
  final http.Client client;
  ApiClient({http.Client? client}) : client = client ?? http.Client();
  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    try {
      final Map<String, String> finalParams = {
        'api_key': ApiConstants.apiKey,
        'language': 'pt-BR',
        ...?params,
      };

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}$endpoint',
      ).replace(queryParameters: finalParams);

      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(
        message: 'Sem conexão com a internet. Verifique seu wi-fi.',
      );
    } on http.ClientException {
      throw NetworkException(message: 'Falha na comunicação com o servidor.');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw GeneralException('Ocorreu um erro inesperado: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode >= 500) {
      throw ServerException('Erro interno do servidor: ${response.statusCode}');
    } else if (response.statusCode == 404) {
      throw NetworkException(message: 'Recurso não encontrado (404).');
    } else {
      throw NetworkException(
        message: 'Erro na requisição: ${response.statusCode}',
      );
    }
  }
}
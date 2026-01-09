import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:paysmart_challenge/core/errors/exceptions.dart';
import 'package:paysmart_challenge/services/api_client.dart';

// Importamos o arquivo de Mocks que geramos na Fase 0
import '../helpers/test_helper.mocks.dart';

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;

  setUp(() {
    // 1. Instanciamos o Mock (o ator que finge ser o http)
    mockHttpClient = MockHttpClient();
    
    // 2. Injetamos o Mock dentro do nosso ApiClient real
    apiClient = ApiClient(client: mockHttpClient);
  });

  group('ApiClient Tests', () {
    const tEndpoint = 'movie/upcoming';
    const tParams = {'page': '1'};
    
    // Cenário 1: Sucesso (HTTP 200)
    test('Deve retornar um Map (JSON) quando o status code for 200 (Sucesso)', () async {
      // ARRANGE (Preparação)
      // "Quando alguém chamar o método GET..."
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('{"results": []}', 200));

      // ACT (Ação)
      final response = await apiClient.get(tEndpoint, params: tParams);

      // ASSERT (Verificação)
      expect(response, isA<Map<String, dynamic>>());
      expect(response.containsKey('results'), true);
    });

    // Cenário 2: Erro de Cliente (HTTP 404)
    test('Deve lançar NetworkException quando o status code for 404 (Não Encontrado)', () async {
      // ARRANGE
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // ACT & ASSERT (Verificar se a exceção foi lançada)
      // Como o método lança erro, usamos o expectLater com throwsA
      expect(
        () => apiClient.get(tEndpoint),
        throwsA(isA<NetworkException>()),
      );
    });

    // Cenário 3: Erro de Servidor (HTTP 500)
    test('Deve lançar ServerException quando o status code for 500 (Erro Interno)', () async {
      // ARRANGE
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Internal Error', 500));

      // ACT & ASSERT
      expect(
        () => apiClient.get(tEndpoint),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
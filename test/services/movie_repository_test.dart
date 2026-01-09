import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:paysmart_challenge/services/api_client.dart';
import 'package:paysmart_challenge/services/movie_repository.dart';
import 'package:paysmart_challenge/models/movie_response.dart';

// Importamos os mocks gerados
import '../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;

  setUp(() {
    // 1. Criamos o mock do HTTP (o único componente falso)
    mockHttpClient = MockHttpClient();
    
    // 2. Montamos o ApiClient real usando o HTTP falso
    apiClient = ApiClient(client: mockHttpClient);
    
    // 3. Montamos o Repositório real usando o ApiClient montado
    repository = MovieRepositoryImpl(apiClient: apiClient);
  });

  group('MovieRepository Tests', () {
    // JSON de exemplo que o "Servidor" retornaria
    const tJsonString = '''
      {
        "page": 1,
        "results": [
          {
            "id": 1,
            "title": "Filme Teste",
            "overview": "Sinopse",
            "release_date": "2023-01-01",
            "genre_ids": [1],
            "vote_average": 8.0,
            "poster_path": "/img.jpg",
            "backdrop_path": "/back.jpg"
          }
        ],
        "total_pages": 1,
        "total_results": 1
      }
    ''';

    test('getUpcomingMovies deve retornar um MovieResponse quando a chamada for bem sucedida', () async {
      // ARRANGE
      // Simulamos que a internet respondeu 200 OK com o JSON acima
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      // ACT
      final result = await repository.getUpcomingMovies(page: 1);

      // ASSERT
      // Verificamos se o Repositório converteu o JSON em Objetos corretamente
      expect(result, isA<MovieResponse>());
      expect(result.results.length, 1);
      expect(result.results.first.title, 'Filme Teste');
    });

    test('searchMovies deve retornar um MovieResponse quando a busca for bem sucedida', () async {
      // ARRANGE
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      // ACT
      final result = await repository.searchMovies('Batman', page: 1);

      // ASSERT
      expect(result, isA<MovieResponse>());
      expect(result.results.isNotEmpty, true);
    });

    test('Deve repassar a Exceção se o ApiClient falhar', () async {
      // ARRANGE
      // Simulamos um erro 404 (que agora sabemos que lança NetworkException)
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // ACT & ASSERT
      // O Repositório não deve engolir o erro, deve repassar para o ViewModel tratar
      expect(
        () => repository.getUpcomingMovies(),
        throwsA(isA<Exception>()), 
      );
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paysmart_challenge/core/errors/exceptions.dart';
import 'package:paysmart_challenge/models/movie_model.dart';
import 'package:paysmart_challenge/models/movie_response.dart';
import 'package:paysmart_challenge/viewmodels/movie_viewmodel.dart';

// Importamos o Mock do Repositório
import '../helpers/test_helper.mocks.dart';

void main() {
  late MovieViewModel viewModel;
  late MockMovieRepository mockRepository;
  
  // Declaramos as variáveis de dados aqui, mas só damos valor no setUp
  late Movie tMovie1;
  late Movie tMovie2;
  late MovieResponse tResponsePage1;
  late MovieResponse tResponsePage2;

  setUp(() {
    mockRepository = MockMovieRepository();
    viewModel = MovieViewModel(repository: mockRepository);

    // --- REINICIALIZAÇÃO DOS DADOS (CRUCIAL!) ---
    // Fazemos isso aqui para garantir que cada teste pegue dados "limpos".
    
    tMovie1 = Movie(
      id: 1, title: 'Filme 1', overview: 'Desc 1', 
      posterPath: '/p1.jpg', backdropPath: '/b1.jpg', 
      releaseDate: '2023-01-01', genreIds: [1], voteAverage: 8.0
    );

    tMovie2 = Movie(
      id: 2, title: 'Filme 2', overview: 'Desc 2',
      posterPath: '/p2.jpg', backdropPath: '/b2.jpg',
      releaseDate: '2023-01-02', genreIds: [1], voteAverage: 7.0
    );

    // [tMovie1] cria uma NOVA lista na memória a cada teste.
    // Isso evita que o .addAll do teste anterior afete o próximo.
    tResponsePage1 = MovieResponse(
      page: 1, results: [tMovie1], totalPages: 2, totalResults: 2
    );
    
    tResponsePage2 = MovieResponse(
      page: 2, results: [tMovie2], totalPages: 2, totalResults: 2
    );
  });

  group('MovieViewModel Tests', () {
    
    test('fetchMovies deve carregar a lista e atualizar o estado corretamente', () async {
      when(mockRepository.getUpcomingMovies(page: 1))
          .thenAnswer((_) async => tResponsePage1);

      expect(viewModel.isLoading, false);
      expect(viewModel.movies, isEmpty);

      await viewModel.fetchMovies();

      expect(viewModel.isLoading, false);
      expect(viewModel.movies.length, 1);
      expect(viewModel.movies.first.title, 'Filme 1');
      expect(viewModel.error, null);
    });

    test('fetchMovies deve setar mensagem de erro quando o repo falhar', () async {
      when(mockRepository.getUpcomingMovies(page: 1))
          .thenThrow(NetworkException(message: 'Sem conexão'));

      await viewModel.fetchMovies();

      expect(viewModel.isLoading, false);
      expect(viewModel.movies, isEmpty);
      expect(viewModel.error, 'Sem conexão');
    });

    test('loadMoreMovies deve ADICIONAR itens à lista existente', () async {
      when(mockRepository.getUpcomingMovies(page: 1))
          .thenAnswer((_) async => tResponsePage1);
      when(mockRepository.getUpcomingMovies(page: 2))
          .thenAnswer((_) async => tResponsePage2);

      // Passo A: Carrega página 1
      await viewModel.fetchMovies();
      expect(viewModel.movies.length, 1);

      // Passo B: Carrega página 2 (Aqui modificamos a lista na memória)
      await viewModel.loadMoreMovies();

      expect(viewModel.movies.length, 2);
      expect(viewModel.movies[1].title, 'Filme 2');
    });

    test('searchMovies deve limpar a lista anterior e trazer resultados da busca', () async {
      when(mockRepository.searchMovies('Batman', page: 1))
          .thenAnswer((_) async => tResponsePage1); // Agora tResponsePage1 está limpo de novo!

      await viewModel.searchMovies('Batman');

      verify(mockRepository.searchMovies('Batman', page: 1)).called(1);
      expect(viewModel.isSearching, true);
      expect(viewModel.movies.length, 1); // Agora vai dar 1 corretamente
    });
  });
}
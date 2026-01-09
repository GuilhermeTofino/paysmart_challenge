import 'package:flutter_test/flutter_test.dart';
import 'package:paysmart_challenge/models/movie_model.dart';

void main() {
  group('Movie Model Test', () {
    // 1. Massa de dados (Um JSON perfeito como viria da API)
    final Map<String, dynamic> jsonValid = {
      "id": 1,
      "title": "Batman",
      "overview": "O homem morcego",
      "poster_path": "/batman.jpg",
      "backdrop_path": "/gotham.jpg",
      "release_date": "2023-01-01",
      "genre_ids": [1, 2],
      "vote_average": 9.5
    };

    test('Deve converter um JSON válido para um objeto Movie corretamente', () {
      // ACT (Ação: Converter)
      final movie = Movie.fromJson(jsonValid);

      // ASSERT (Verificação)
      expect(movie.id, 1);
      expect(movie.title, "Batman");
      expect(movie.voteAverage, 9.5);
      expect(movie.genreIds, [1, 2]);
    });

    test('Deve tratar campos nulos/faltantes com valores padrão (sem quebrar)', () {
      // JSON faltando quase tudo (cenário de erro da API)
      final Map<String, dynamic> jsonEmpty = {
        "id": 2,
        // title faltando
        // overview faltando
        // poster_path faltando
      };

      final movie = Movie.fromJson(jsonEmpty);

      // Verificamos se ele assumiu os valores padrão que definimos no Model
      expect(movie.title, 'Título Desconhecido');
      expect(movie.overview, 'Sem descrição disponível.');
      expect(movie.posterPath, null);
    });

    test('fullPosterUrl deve gerar a URL completa correta', () {
      final movie = Movie.fromJson(jsonValid);
      
      // Deve concatenar a URL base do TMDb com o caminho da imagem
      expect(movie.fullPosterUrl, 'https://image.tmdb.org/t/p/w500/batman.jpg');
    });

    test('fullPosterUrl deve retornar placeholder se não houver imagem', () {
      final movie = Movie.fromJson({"id": 3}); // Sem poster_path
      
      // Deve conter o link do placeholder
      expect(movie.fullPosterUrl, contains('placeholder.com'));
    });
  });
}
class ApiConstants {
  /// URL base da API do The Movie Database (TMDb).
  static const String baseUrl = 'https://api.themoviedb.org/3';

  /// URL base para carregamento de imagens (configurado para largura w500).
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  /// Chave de acesso à API.
  static const String apiKey = '909c134d9f0c836470db6627e1ac3ab2'; 
  
  // --- Endpoints ---

  /// Rota para buscar filmes que serão lançados em breve.
  static const String upcomingMovies = '/movie/upcoming';

  /// Rota para pesquisar filmes por texto.
  static const String searchMovies = '/search/movie';
}
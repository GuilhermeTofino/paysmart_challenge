import 'movie_model.dart';

class MovieResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'] ?? 1,
      // Mapeia a lista 'results' do JSON para uma List<Movie>
      results: (json['results'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
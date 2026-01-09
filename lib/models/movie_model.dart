import '../core/constants/api_constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;   // Capa do filme (vertical)
  final String? backdropPath; // Imagem de fundo (horizontal)
  final String releaseDate;
  final List<int> genreIds;
  final double voteAverage;  

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.genreIds,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Título Desconhecido',
      overview: json['overview'] ?? 'Sem descrição disponível.',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  String get fullPosterUrl {
    if (posterPath == null) return 'https://via.placeholder.com/154x231';
    return '${ApiConstants.baseImageUrl}$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath == null) return 'https://via.placeholder.com/500x281';
    return '${ApiConstants.baseImageUrl}$backdropPath';
  }
}
import '../core/constants/api_constants.dart';
import '../models/movie_response.dart';
import 'api_client.dart';

abstract class MovieRepository {
  Future<MovieResponse> getUpcomingMovies({int page = 1});
  Future<MovieResponse> searchMovies(String query, {int page = 1});
}
class MovieRepositoryImpl implements MovieRepository {
  final ApiClient _apiClient;

  MovieRepositoryImpl({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<MovieResponse> getUpcomingMovies({int page = 1}) async {
    final response = await _apiClient.get(
      ApiConstants.upcomingMovies,
      params: {'page': page.toString()},
    );

    return MovieResponse.fromJson(response);
  }

  @override
  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    final response = await _apiClient.get(
      ApiConstants.searchMovies,
      params: {
        'query': query,
        'page': page.toString(),
      },
    );

    return MovieResponse.fromJson(response);
  }
}
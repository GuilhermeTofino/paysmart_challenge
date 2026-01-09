import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../services/movie_repository.dart';
import '../core/errors/exceptions.dart';
class MovieViewModel extends ChangeNotifier {
  final MovieRepository _repository;
  MovieViewModel({MovieRepository? repository})
      : _repository = repository ?? MovieRepositoryImpl();
  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  String _currentQuery = ''; 
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get isSearching => _currentQuery.isNotEmpty;
  Future<void> searchMovies(String query) async {
    _currentQuery = query;
    _currentPage = 1;
    _movies.clear(); 
    await fetchMovies();
  }

  Future<void> fetchMovies() async {
    if (_currentPage == 1) _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = _currentQuery.isEmpty
          ? await _repository.getUpcomingMovies(page: _currentPage)
          : await _repository.searchMovies(_currentQuery, page: _currentPage);
      
      if (_currentPage == 1) {
        _movies = response.results;
      } else {
        _movies.addAll(response.results);
      }
      
      _totalPages = response.totalPages;
      
    } catch (e) {
      _error = _formatError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMovies() async {
    if (_isLoadingMore || _isLoading || _currentPage >= _totalPages) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      await fetchMovies();
    } catch (e) {
      debugPrint('Erro na paginação: $e');
      _currentPage--;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  String _formatError(dynamic e) {
    if (e is NetworkException || e is ServerException) {
      return e.message;
    }
    return 'Ocorreu um erro desconhecido.';
  }
}
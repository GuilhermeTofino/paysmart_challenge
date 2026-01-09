import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:paysmart_challenge/services/movie_repository.dart';

// Esta anotação diz quais classes queremos "fingir" (mockar)
@GenerateMocks(
  [],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
    MockSpec<MovieRepository>(as: #MockMovieRepository),
  ],
)
void main() {}
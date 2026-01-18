import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<Movie> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}

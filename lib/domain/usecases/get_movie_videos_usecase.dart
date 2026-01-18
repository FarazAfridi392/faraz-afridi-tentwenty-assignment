import '../entities/movie_video.dart';
import '../repositories/movie_repository.dart';

class GetMovieVideosUseCase {
  final MovieRepository repository;

  GetMovieVideosUseCase(this.repository);

  Future<List<MovieVideo>> call(int movieId) {
    return repository.getMovieVideos(movieId);
  }
}

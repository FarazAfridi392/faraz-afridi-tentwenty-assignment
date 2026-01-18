import '../entities/movie.dart';
import '../entities/movie_image.dart';
import '../entities/movie_video.dart';

abstract class MovieRepository {
  
  Future<List<Movie>> getUpcomingMovies({int page = 1});

  
  Future<Movie> getMovieDetails(int movieId);

  
  Future<MovieImages> getMovieImages(int movieId);

  
  Future<List<MovieVideo>> getMovieVideos(int movieId);

  
  Future<List<Movie>> searchMovies(String query);
}

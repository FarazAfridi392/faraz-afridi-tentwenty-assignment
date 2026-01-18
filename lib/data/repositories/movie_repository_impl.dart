import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_image.dart';
import '../../domain/entities/movie_video.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_api_service.dart';
import '../datasources/local/movie_local_data_source.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService apiService;
  final MovieLocalDataSource localDataSource;
  final Connectivity connectivity;

  MovieRepositoryImpl(this.apiService, this.localDataSource, this.connectivity);

  Future<bool> _isConnected() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      if (await _isConnected()) {
        final models = await apiService.fetchUpcomingMovies(page: page);
        final movies = models.map((e) => e.toEntity()).toList();

        await localDataSource.cacheMovies(movies);
        return movies;
      } else {
        return await localDataSource.getUpcomingMovies();
      }
    } catch (e) {
      return await localDataSource.getUpcomingMovies();
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      if (await _isConnected()) {
        final model = await apiService.fetchMovieDetails(movieId);
        print("GENRES: ${model.genres}");
        final movie = model.toEntity();
        print(movie.genres);
        await localDataSource.cacheMovie(movie);
        return movie;
      } else {
        final cachedMovie = await localDataSource.getMovieById(movieId);
        if (cachedMovie != null) {
          return cachedMovie;
        }
        throw Exception('No internet connection and movie not in cache');
      }
    } catch (e) {
      final cachedMovie = await localDataSource.getMovieById(movieId);
      if (cachedMovie != null) {
        return cachedMovie;
      }
      rethrow;
    }
  }

  @override
  Future<MovieImages> getMovieImages(int movieId) async {
    if (await _isConnected()) {
      final model = await apiService.fetchMovieImages(movieId);
      return model.toEntity();
    }
    throw Exception('No internet connection');
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(int movieId) async {
    if (await _isConnected()) {
      final models = await apiService.fetchMovieVideos(movieId);
      return models.map((e) => e.toEntity()).toList();
    }
    throw Exception('No internet connection');
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      if (await _isConnected()) {
        final models = await apiService.searchMovies(query);
        final movies = models.map((e) => e.toEntity()).toList();

        return movies;
      } else {
        return await localDataSource.searchMovies(query);
      }
    } catch (e) {
      return await localDataSource.searchMovies(query);
    }
  }
}

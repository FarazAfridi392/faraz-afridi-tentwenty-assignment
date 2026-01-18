import 'dart:convert';
import 'package:tentwenty_assignment/data/datasources/local/dao/movie_dao.dart';
import 'package:tentwenty_assignment/data/datasources/local/entities/movie_entity.dart';

import '../../../domain/entities/movie.dart';

class MovieLocalDataSource {
  final MovieDao movieDao;

  MovieLocalDataSource(this.movieDao);

  Future<List<Movie>> getUpcomingMovies() async {
    final entities = await movieDao.getAllMovies();
    return entities.map((e) => _entityToMovie(e)).toList();
  }

  Future<Movie?> getMovieById(int id) async {
    final entity = await movieDao.getMovieById(id);
    return entity != null ? _entityToMovie(entity) : null;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final entities = await movieDao.searchMovies('%$query%');
    return entities.map((e) => _entityToMovie(e)).toList();
  }

  Future<void> cacheMovies(List<Movie> movies) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final entities = movies.map((m) => _movieToEntity(m, timestamp)).toList();
    await movieDao.insertMovies(entities);
  }

  Future<void> cacheMovie(Movie movie) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final entity = _movieToEntity(movie, timestamp);

    await movieDao.insertMovie(entity);
  }

  Future<void> clearOldCache() async {
    final oneWeekAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .millisecondsSinceEpoch;
    await movieDao.deleteOldMovies(oneWeekAgo);
  }

  MovieEntity _movieToEntity(Movie movie, int timestamp) {
    return MovieEntity(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      rating: movie.rating,
      genreIds: jsonEncode(movie.genreIds),
      timestamp: timestamp,
    );
  }

  Movie _entityToMovie(MovieEntity entity) {
    return Movie(
      id: entity.id,
      title: entity.title,
      overview: entity.overview,
      posterPath: entity.posterPath,
      backdropPath: entity.backdropPath,
      releaseDate: entity.releaseDate,
      rating: entity.rating,
      genreIds: jsonDecode(entity.genreIds).cast<int>(),
    );
  }
}

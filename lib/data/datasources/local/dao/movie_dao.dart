import 'package:floor/floor.dart';
import '../entities/movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM movies ORDER BY timestamp DESC')
  Future<List<MovieEntity>> getAllMovies();

  @Query('SELECT * FROM movies WHERE id = :id')
  Future<MovieEntity?> getMovieById(int id);

  @Query('SELECT * FROM movies WHERE title LIKE :query OR overview LIKE :query')
  Future<List<MovieEntity>> searchMovies(String query);

  @insert
  Future<void> insertMovie(MovieEntity movie);

  @insert
  Future<void> insertMovies(List<MovieEntity> movies);

  @update
  Future<void> updateMovie(MovieEntity movie);

  @delete
  Future<void> deleteMovie(MovieEntity movie);

  @Query('DELETE FROM movies')
  Future<void> deleteAllMovies();

  @Query('DELETE FROM movies WHERE timestamp < :timestamp')
  Future<void> deleteOldMovies(int timestamp);
}

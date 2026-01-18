import 'package:floor/floor.dart';

@Entity(tableName: 'movies')
class MovieEntity {
  @primaryKey
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double rating;
  final String genreIds;
  final int timestamp;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.rating,
    required this.genreIds,
    required this.timestamp,
  });
}

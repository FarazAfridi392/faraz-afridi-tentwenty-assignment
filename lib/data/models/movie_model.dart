import '../../domain/entities/movie.dart';

class MovieModel {
  final int? id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? rating;
  final List<int>? genreIds;
  final List<Genre>? genres;
  final String? tagline;
  final int? runtime;

  MovieModel({
    this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.rating,
    this.genreIds,
    this.genres,
    this.tagline,
    this.runtime,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final List<Genre>? parsedGenres = json['genres'] != null
        ? (json['genres'] as List)
              .where((g) => g['id'] != null && g['name'] != null)
              .map((g) => Genre(id: g['id'] as int, name: g['name'] as String))
              .toList()
        : null;

    final List<int>? parsedGenreIds = json['genre_ids'] != null
        ? List<int>.from(json['genre_ids'])
        : parsedGenres?.map((g) => g.id!).toList();

    return MovieModel(
      id: json['id'] as int?,
      title: json['title'] ?? json['original_title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      rating: (json['vote_average'] as num?)?.toDouble(),
      genreIds: parsedGenreIds,
      genres: parsedGenres,
      tagline: json['tagline'],
      runtime: json['runtime'] as int?,
    );
  }

  Movie toEntity() {
    return Movie(
      id: id ?? 0,
      title: title ?? '',
      overview: overview ?? '',
      posterPath: posterPath ?? '',
      backdropPath: backdropPath ?? '',
      releaseDate: releaseDate ?? '',
      rating: rating ?? 0.0,
      genreIds: genreIds ?? const [],
      genres: genres,
      tagline: tagline,
      runtime: runtime,
    );
  }
}

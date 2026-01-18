import '../../domain/entities/movie_video.dart';

class MovieVideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  MovieVideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) {
    return MovieVideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  MovieVideo toEntity() {
    return MovieVideo(
      id: id,
      key: key,
      name: name,
      site: site,
      type: type,
      official: official,
    );
  }
}

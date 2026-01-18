import '../../domain/entities/movie_image.dart';

class MovieImageModel {
  final String filePath;
  final double aspectRatio;
  final int height;
  final int width;

  MovieImageModel({
    required this.filePath,
    required this.aspectRatio,
    required this.height,
    required this.width,
  });

  factory MovieImageModel.fromJson(Map<String, dynamic> json) {
    return MovieImageModel(
      filePath: json['file_path'] ?? '',
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 0.0,
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
    );
  }

  MovieImage toEntity() {
    return MovieImage(
      filePath: filePath,
      aspectRatio: aspectRatio,
      height: height,
      width: width,
    );
  }
}

class MovieImagesModel {
  final List<MovieImageModel> backdrops;
  final List<MovieImageModel> posters;

  MovieImagesModel({required this.backdrops, required this.posters});

  factory MovieImagesModel.fromJson(Map<String, dynamic> json) {
    return MovieImagesModel(
      backdrops:
          (json['backdrops'] as List?)
              ?.map((e) => MovieImageModel.fromJson(e))
              .toList() ??
          [],
      posters:
          (json['posters'] as List?)
              ?.map((e) => MovieImageModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  MovieImages toEntity() {
    return MovieImages(
      backdrops: backdrops.map((e) => e.toEntity()).toList(),
      posters: posters.map((e) => e.toEntity()).toList(),
    );
  }
}

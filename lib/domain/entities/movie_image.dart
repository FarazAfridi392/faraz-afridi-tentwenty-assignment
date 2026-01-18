import 'package:equatable/equatable.dart';

class MovieImage extends Equatable {
  final String filePath;
  final double aspectRatio;
  final int height;
  final int width;

  const MovieImage({
    required this.filePath,
    required this.aspectRatio,
    required this.height,
    required this.width,
  });

  @override
  List<Object?> get props => [filePath, aspectRatio, height, width];
}

class MovieImages extends Equatable {
  final List<MovieImage> backdrops;
  final List<MovieImage> posters;

  const MovieImages({required this.backdrops, required this.posters});

  @override
  List<Object?> get props => [backdrops, posters];
}

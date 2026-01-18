import 'package:dio/dio.dart';
import '../../../core/utils/constants.dart';
import '../../models/movie_model.dart';
import '../../models/movie_image_model.dart';
import '../../models/movie_video_model.dart';

class MovieApiService {
  final Dio dio;

  MovieApiService(this.dio);

  Future<List<MovieModel>> fetchUpcomingMovies({int page = 1}) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/movie/upcoming',
      queryParameters: {'api_key': AppConstants.apiKey, 'page': page},
    );
    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<MovieModel> fetchMovieDetails(int movieId) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/movie/$movieId',
      queryParameters: {'api_key': AppConstants.apiKey},
    );
    print(response.data);

    return MovieModel.fromJson(response.data);
  }

  Future<MovieImagesModel> fetchMovieImages(int movieId) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/movie/$movieId/images',
      queryParameters: {'api_key': AppConstants.apiKey},
    );

    return MovieImagesModel.fromJson(response.data);
  }

  Future<List<MovieVideoModel>> fetchMovieVideos(int movieId) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/movie/$movieId/videos',
      queryParameters: {'api_key': AppConstants.apiKey},
    );

    final List results = response.data['results'] ?? [];
    return results.map((e) => MovieVideoModel.fromJson(e)).toList();
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}/search/movie',
      queryParameters: {'api_key': AppConstants.apiKey, 'query': query},
    );

    final List results = response.data['results'] ?? [];
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }
}

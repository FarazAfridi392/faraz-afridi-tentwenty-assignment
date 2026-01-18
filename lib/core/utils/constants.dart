import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('TMDB_API_KEY not found in .env file');
    }
    return key;
  }

  

  static const Duration debounceDuration = Duration(milliseconds: 400);
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tentwenty_assignment/core/utils/constants.dart';
import 'package:tentwenty_assignment/domain/entities/movie.dart';
import 'package:tentwenty_assignment/presentation/screens/movie_detail/widgets/header_buttons.dart';

class Header extends StatelessWidget {
  final Movie movie;

  const Header({required this.movie});

  String formatDate(String date) {
    final d = DateTime.parse(date);
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: '${AppConstants.imageBaseUrl}${movie.backdropPath}',
            height: 520,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
            height: 520,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black45, Colors.black87],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Watch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'In Theaters ${formatDate(movie.releaseDate)}',
                  style: const TextStyle(
                    color: Color(0xFF4AA3F7),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                HeaderButtons(movieId: movie.id, title: movie.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

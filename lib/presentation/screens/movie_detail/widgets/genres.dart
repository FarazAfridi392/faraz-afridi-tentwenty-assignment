import 'package:flutter/material.dart';
import 'package:tentwenty_assignment/domain/entities/movie.dart';

class Genres extends StatelessWidget {
  final List<Genre> genres;

  const Genres(this.genres, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFF2ECC71),
      Color(0xFFFF6B81),
      Color(0xFF6C5CE7),
      Color(0xFFF1C40F),
    ];
    print(genres);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genres',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres.asMap().entries.map((e) {
            return Chip(
              backgroundColor: colors[e.key % colors.length],
              label: Text(
                e.value.name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tentwenty_assignment/presentation/providers/movie_list_provider.dart';
import 'package:tentwenty_assignment/presentation/screens/show_time/show_time_screen.dart';
import 'package:tentwenty_assignment/presentation/screens/seat_selection/seat_selection_screen.dart';
import 'package:tentwenty_assignment/presentation/screens/video_player_screen.dart';

class HeaderButtons extends ConsumerWidget {
  final int movieId;
  final String title;

  const HeaderButtons({required this.movieId, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(movieVideosProvider(movieId));
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4AA3F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShowtimeScreen(title: title)),
              );
            },
            child: const Text(
              'Get Tickets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              'Watch Trailer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(movieId: movieId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

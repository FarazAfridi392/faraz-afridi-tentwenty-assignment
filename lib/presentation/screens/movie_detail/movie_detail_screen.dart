import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tentwenty_assignment/presentation/screens/movie_detail/widgets/genres.dart';
import 'package:tentwenty_assignment/presentation/screens/movie_detail/widgets/header.dart';
import 'package:tentwenty_assignment/presentation/screens/movie_detail/widgets/overview.dart';

import '../../providers/movie_list_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: movieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (movie) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(movie: movie),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    movie.genres == null || movie.genres!.isEmpty
                        ? SizedBox()
                        : Genres(movie.genres ?? []),
                    const SizedBox(height: 24),
                    Overview(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

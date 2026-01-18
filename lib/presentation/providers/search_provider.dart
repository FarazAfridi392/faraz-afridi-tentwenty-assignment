import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:tentwenty_assignment/presentation/providers/movie_list_provider.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/search_movies_usecase.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.read(movieRepositoryProvider.future);
  return SearchMoviesUseCase(repository);
});

final searchResultsProvider = FutureProvider.family<List<Movie>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final repository = await ref.read(movieRepositoryProvider.future);
  final useCase = SearchMoviesUseCase(repository);
  return useCase.call(query);
});

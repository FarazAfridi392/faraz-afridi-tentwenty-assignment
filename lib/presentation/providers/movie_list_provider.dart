import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_video.dart';
import '../../domain/usecases/get_upcoming_movies_usecase.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/get_movie_videos_usecase.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/datasources/remote/movie_api_service.dart';
import '../../data/datasources/local/movie_local_data_source.dart';
import '../../data/datasources/local/database/app_database.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final dioProvider = Provider((_) => Dio());
final connectivityProvider = Provider((_) => Connectivity());

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
});

final movieDaoProvider = FutureProvider((ref) async {
  final database = await ref.read(databaseProvider.future);
  return database.movieDao;
});

final movieLocalDataSourceProvider = FutureProvider((ref) async {
  final dao = await ref.read(movieDaoProvider.future);
  return MovieLocalDataSource(dao);
});

final movieApiProvider = Provider(
  (ref) => MovieApiService(ref.read(dioProvider)),
);

final movieRepositoryProvider = FutureProvider((ref) async {
  final apiService = ref.read(movieApiProvider);
  final localDataSource = await ref.read(movieLocalDataSourceProvider.future);
  final connectivity = ref.read(connectivityProvider);
  return MovieRepositoryImpl(apiService, localDataSource, connectivity);
});

final getUpcomingMoviesProvider = FutureProvider((ref) async {
  final repository = await ref.read(movieRepositoryProvider.future);
  return GetUpcomingMoviesUseCase(repository);
});

final getMovieDetailsProvider = FutureProvider((ref) async {
  final repository = await ref.read(movieRepositoryProvider.future);

  return GetMovieDetailsUseCase(repository);
});

final getMovieVideosProvider = FutureProvider((ref) async {
  final repository = await ref.read(movieRepositoryProvider.future);
  return GetMovieVideosUseCase(repository);
});

class PaginatedMoviesState {
  final List<Movie> movies;
  final bool hasNextPage;
  final bool isLoading;
  final String? error;

  PaginatedMoviesState({
    required this.movies,
    this.hasNextPage = true,
    this.isLoading = false,
    this.error,
  });

  PaginatedMoviesState copyWith({
    List<Movie>? movies,
    bool? hasNextPage,
    bool? isLoading,
    String? error,
  }) {
    return PaginatedMoviesState(
      movies: movies ?? this.movies,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MovieListNotifier extends StateNotifier<PaginatedMoviesState> {
  final Future<GetUpcomingMoviesUseCase> useCaseFuture;
  int _page = 1;

  MovieListNotifier(this.useCaseFuture)
    : super(PaginatedMoviesState(movies: [])) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (!state.hasNextPage || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = await useCaseFuture;
      final newMovies = await useCase.call(page: _page);

      final hasNext = newMovies.isNotEmpty;
      _page++;

      state = state.copyWith(
        movies: [...state.movies, ...newMovies],
        hasNextPage: hasNext,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    _page = 1;
    state = PaginatedMoviesState(movies: []);
    await fetchNextPage();
  }
}

final movieListNotifierProvider =
    StateNotifierProvider<MovieListNotifier, PaginatedMoviesState>((ref) {
      final useCaseFuture = ref.watch(getUpcomingMoviesProvider.future);
      return MovieListNotifier(useCaseFuture);
    });

final movieDetailsProvider = FutureProvider.family<Movie, int>((
  ref,
  movieId,
) async {
  final useCase = await ref.read(getMovieDetailsProvider.future);
  print("Use Case: $useCase");
  return useCase.call(movieId);
});

final movieVideosProvider = FutureProvider.family<List<MovieVideo>, int>((
  ref,
  movieId,
) async {
  final useCase = await ref.read(getMovieVideosProvider.future);
  return useCase.call(movieId);
});

part of 'app_database.dart';

abstract class $AppDatabaseBuilderContract {
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  $AppDatabaseBuilderContract addCallback(Callback callback);

  Future<AppDatabase> build();
}

class $FloorAppDatabase {
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(path, _migrations, _callback);
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MovieDao? _movieDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
          database,
          startVersion,
          endVersion,
          migrations,
        );

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `movies` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `overview` TEXT NOT NULL, `posterPath` TEXT NOT NULL, `backdropPath` TEXT NOT NULL, `releaseDate` TEXT NOT NULL, `rating` REAL NOT NULL, `genreIds` TEXT NOT NULL, `timestamp` INTEGER NOT NULL, PRIMARY KEY (`id`))',
        );

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database),
      _movieEntityInsertionAdapter = InsertionAdapter(
        database,
        'movies',
        (MovieEntity item) => <String, Object?>{
          'id': item.id,
          'title': item.title,
          'overview': item.overview,
          'posterPath': item.posterPath,
          'backdropPath': item.backdropPath,
          'releaseDate': item.releaseDate,
          'rating': item.rating,
          'genreIds': item.genreIds,
          'timestamp': item.timestamp,
        },
      ),
      _movieEntityUpdateAdapter = UpdateAdapter(
        database,
        'movies',
        ['id'],
        (MovieEntity item) => <String, Object?>{
          'id': item.id,
          'title': item.title,
          'overview': item.overview,
          'posterPath': item.posterPath,
          'backdropPath': item.backdropPath,
          'releaseDate': item.releaseDate,
          'rating': item.rating,
          'genreIds': item.genreIds,
          'timestamp': item.timestamp,
        },
      ),
      _movieEntityDeletionAdapter = DeletionAdapter(
        database,
        'movies',
        ['id'],
        (MovieEntity item) => <String, Object?>{
          'id': item.id,
          'title': item.title,
          'overview': item.overview,
          'posterPath': item.posterPath,
          'backdropPath': item.backdropPath,
          'releaseDate': item.releaseDate,
          'rating': item.rating,
          'genreIds': item.genreIds,
          'timestamp': item.timestamp,
        },
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieEntity> _movieEntityInsertionAdapter;

  final UpdateAdapter<MovieEntity> _movieEntityUpdateAdapter;

  final DeletionAdapter<MovieEntity> _movieEntityDeletionAdapter;

  @override
  Future<List<MovieEntity>> getAllMovies() async {
    return _queryAdapter.queryList(
      'SELECT * FROM movies ORDER BY timestamp DESC',
      mapper: (Map<String, Object?> row) => MovieEntity(
        id: row['id'] as int,
        title: row['title'] as String,
        overview: row['overview'] as String,
        posterPath: row['posterPath'] as String,
        backdropPath: row['backdropPath'] as String,
        releaseDate: row['releaseDate'] as String,
        rating: row['rating'] as double,
        genreIds: row['genreIds'] as String,
        timestamp: row['timestamp'] as int,
      ),
    );
  }

  @override
  Future<MovieEntity?> getMovieById(int id) async {
    return _queryAdapter.query(
      'SELECT * FROM movies WHERE id = ?1',
      mapper: (Map<String, Object?> row) => MovieEntity(
        id: row['id'] as int,
        title: row['title'] as String,
        overview: row['overview'] as String,
        posterPath: row['posterPath'] as String,
        backdropPath: row['backdropPath'] as String,
        releaseDate: row['releaseDate'] as String,
        rating: row['rating'] as double,
        genreIds: row['genreIds'] as String,
        timestamp: row['timestamp'] as int,
      ),
      arguments: [id],
    );
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    return _queryAdapter.queryList(
      'SELECT * FROM movies WHERE title LIKE ?1 OR overview LIKE ?1',
      mapper: (Map<String, Object?> row) => MovieEntity(
        id: row['id'] as int,
        title: row['title'] as String,
        overview: row['overview'] as String,
        posterPath: row['posterPath'] as String,
        backdropPath: row['backdropPath'] as String,
        releaseDate: row['releaseDate'] as String,
        rating: row['rating'] as double,
        genreIds: row['genreIds'] as String,
        timestamp: row['timestamp'] as int,
      ),
      arguments: [query],
    );
  }

  @override
  Future<void> deleteAllMovies() async {
    await _queryAdapter.queryNoReturn('DELETE FROM movies');
  }

  @override
  Future<void> deleteOldMovies(int timestamp) async {
    await _queryAdapter.queryNoReturn(
      'DELETE FROM movies WHERE timestamp < ?1',
      arguments: [timestamp],
    );
  }

  @override
  Future<void> insertMovie(MovieEntity movie) async {
    await _movieEntityInsertionAdapter.insert(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMovies(List<MovieEntity> movies) async {
    await _movieEntityInsertionAdapter.insertList(
      movies,
      OnConflictStrategy.abort,
    );
  }

  @override
  Future<void> updateMovie(MovieEntity movie) async {
    await _movieEntityUpdateAdapter.update(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMovie(MovieEntity movie) async {
    await _movieEntityDeletionAdapter.delete(movie);
  }
}

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tentwenty_assignment/data/datasources/local/dao/movie_dao.dart';
import 'package:tentwenty_assignment/data/datasources/local/entities/movie_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [MovieEntity])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}

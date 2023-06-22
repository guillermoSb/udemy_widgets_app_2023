import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

// Read Only Provider that will expose the provider to all the widgets / screens
final movieRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepositoryImplementation(MovieDbDatasource());
});

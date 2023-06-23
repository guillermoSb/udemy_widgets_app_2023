import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviesRepositoryImplementation extends MoviesRepository {
  final MoviesDatasource _datasource;
  MoviesRepositoryImplementation(this._datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) =>
      _datasource.getNowPlaying(page: page);

  @override
  Future<List<Movie>> getPopular({int page = 1}) =>
      _datasource.getPopular(page: page);

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) =>
      _datasource.getUpcoming(page: page);

  @override
  Future<List<Movie>> getTopRated({int page = 1}) =>
      _datasource.getTopRated(page: page);

  @override
  Future<Movie> getMovieById(String id) => _datasource.getMovieById(id);

  @override
  Future<List<Movie>> searchMovies(String query) =>
      _datasource.searchMovies(query);
}

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetMovieCallback = Future<Movie> Function(String movieId);

// This provider is in charge of getting the movie from the repository
final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: getMovie);
});

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapNotifier({
    required this.getMovie,
  }) : super({}); // At the start the map is empty

  Future<void> loadMovie(String id) async {
    if (state.containsKey(id)) {
      return; // Do not load if the movie is already loaded
    }
    final movie = await getMovie(id);
    state = {...state, id: movie};
  }
}

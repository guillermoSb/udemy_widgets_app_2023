import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMoviesCallback;
  StreamController<List<Movie>> debouncedMovies = StreamController
      .broadcast(); // we use broadcast to have multiple listeners

  StreamController<bool> isLoading = StreamController.broadcast();

  Timer? _debounceTimer;
  List<Movie> initialMovies;

  SearchMovieDelegate(
      {required this.searchMoviesCallback, required this.initialMovies});

  void clearStreams() {
    debouncedMovies.close();
    isLoading.close();
  }

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    isLoading.add(true);
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMoviesCallback(query);
      initialMovies = movies;
      isLoading.add(false);
      return debouncedMovies.add(movies);
    });
  }

  @override
  String? get searchFieldLabel => 'Buscar plelícula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoading.stream,
          initialData: false,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;
            if (isLoading) {
              return SpinPerfect(
                spins: 10,
                infinite: true,
                duration: const Duration(seconds: 20),
                child: IconButton(
                  onPressed: () {
                    query = '';
                  },
                  icon: const Icon(Icons.refresh),
                ),
              );
            }
            return FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.clear),
              ),
            );
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions(context, initialData: initialMovies);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResultsAndSuggestions(context,
        needsToMakeRequest: true, initialData: initialMovies);
  }

  Widget buildResultsAndSuggestions(BuildContext context,
      {needsToMakeRequest = false, List<Movie> initialData = const []}) {
    if (needsToMakeRequest) {
      _onQueryChanged(query);
    }
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return FadeInLeft(
              duration: const Duration(milliseconds: 20),
              child: _MovieItem(
                movie: movie,
                onMovieSelected: (context, movie) {
                  clearStreams();
                  close(context, movie);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Function onMovieSelected;
  final Movie movie;
  const _MovieItem({required this.movie, required this.onMovieSelected});
  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: size.width * 0.20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) {
                    return FadeIn(
                      child: child,
                    );
                  },
                ),
              ),
            )
            // Description
            ,
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                        )
                      : Text(movie.overview),
                  // Puntuación
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade800),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage, 2),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

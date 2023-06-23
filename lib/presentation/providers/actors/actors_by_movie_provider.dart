import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

// This provider is in charge of getting the movie from the repository
final actorMapProvider =
    StateNotifierProvider<ActorMapNotifier, Map<String, List<Actor>>>((ref) {
  final getActors = ref.watch(actorRepositoryProvider).getActorsByMovie;
  return ActorMapNotifier(getActors: getActors);
});

class ActorMapNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;
  ActorMapNotifier({
    required this.getActors,
  }) : super({}); // At the start the map is empty

  Future<void> loadActors(String movieId) async {
    if (state.containsKey(movieId)) {
      return; // Do not load if the movie is already loaded
    }
    final actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}

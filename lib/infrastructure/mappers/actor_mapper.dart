import 'package:cinemapedia/infrastructure/models/moviedb/credits_moviedb.dart';

import '../../domain/entities/actor.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) {
    return Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://cdn.onlinewebfonts.com/svg/img_510068.png',
        character: cast.character);
  }
}

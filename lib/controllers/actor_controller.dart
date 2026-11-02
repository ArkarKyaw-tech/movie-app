import 'package:flutter/material.dart';
import 'package:movie_app/models/actor_model.dart';
import 'package:movie_app/models/known_for_model.dart';
import 'package:movie_app/services/tmdb_api_service.dart';

class ActorProvider extends ChangeNotifier {
  final TmdbApiService _api;

  ActorProvider(this._api);

  Future<ActorModel> fetchActorDetails(int id) {
    return _api.getActorDetails(id);
  }

  Future<List<KnownForModel>> fetchActorKnownFor(int id) {
    return _api.getActorKnownFor(id);
  }
}

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/actor_model.dart';
import 'package:movie_app/models/cast_model.dart';
import 'package:movie_app/models/known_for_model.dart';

import '../models/movie_model.dart';
import '../models/tv_model.dart';

class TmdbApiService {
  TmdbApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  final String _token = dotenv.env['ACCESS_TOKEN'] ?? '';

  // static const String _token = String.fromEnvironment('ACCESS_TOKEN');

  Future<Map<String, dynamic>> _get(String endpoint) async {
    if (_token.isEmpty) {
      throw Exception('No Access Token');
    }

    final url = Uri.parse('$_baseUrl$endpoint');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('TMDB API Error: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    return decoded;
  }

  Future<List<MovieModel>> getPopularMovies() async {
    final data = await _get('/movie/popular');

    final results = data['results'] as List? ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList();
  }

  Future<List<TvModel>> getPopularTvSeries() async {
    final data = await _get('/tv/popular');

    final results = data['results'] as List? ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(TvModel.fromJson)
        .toList();
  }

  Future<MovieModel> getMovieDetails(int id) async {
    final data = await _get('/movie/$id');
    return MovieModel.fromJson(data);
  }

  Future<TvModel> getTvDetails(int id) async {
    final data = await _get('/tv/$id');
    return TvModel.fromJson(data);
  }

  Future<List<CastModel>> getMovieCast(int id) async {
    final data = await _get('/movie/$id/credits');

    final castJson = data['cast'] as List<dynamic>? ?? [];

    return castJson
        .whereType<Map<String, dynamic>>()
        .map(CastModel.fromJson)
        .toList();
  }

  Future<List<CastModel>> getTvCast(int id) async {
    final data = await _get('/tv/$id/credits');

    final castJson = data['cast'] as List<dynamic>? ?? [];

    return castJson
        .map((item) => CastModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ActorModel> getActorDetails(int personId) async {
    final data = await _get('/person/$personId');

    return ActorModel.fromJson(data);
  }

  Future<List<KnownForModel>> getActorKnownFor(int personId) async {
    final data = await _get('/person/$personId/combined_credits');

    final castData = data['cast'] as List<dynamic>? ?? [];

    return castData
        .map((item) => KnownForModel.formJson(item as Map<String, dynamic>))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}

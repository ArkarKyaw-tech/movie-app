import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';
import '../models/tv_model.dart';

class TmdbApiService {
  TmdbApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static const String _token = String.fromEnvironment('ACCESS_TOKEN');

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

  void dispose() {
    _client.close();
  }
}

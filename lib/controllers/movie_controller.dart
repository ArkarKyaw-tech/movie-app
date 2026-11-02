import 'package:flutter/material.dart';
import 'package:movie_app/models/cast_model.dart';
import 'package:movie_app/models/movie_model.dart';

import 'package:movie_app/services/tmdb_api_service.dart';

class MovieProvider extends ChangeNotifier {
  MovieProvider(this._api);

  final TmdbApiService _api;

  List<MovieModel> _movies = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MovieModel> get movies => List.unmodifiable(_movies);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPopularMovies({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_movies.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _movies = await _api.getPopularMovies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MovieModel> fetchMovieDetails(int id) {
    return _api.getMovieDetails(id);
  }

  Future<List<CastModel>> fetchMovieCast(int id) {
    return _api.getMovieCast(id);
  }
}

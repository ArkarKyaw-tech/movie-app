import 'package:flutter/material.dart';
import 'package:movie_app/models/cast_model.dart';
import 'package:movie_app/services/tmdb_api_service.dart';

class CastProvider extends ChangeNotifier {
  final TmdbApiService _api;
  CastProvider(this._api);

  List<CastModel> _cast = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CastModel> get cast => List.unmodifiable(_cast);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMovieCast(int movieId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _cast = await _api.getMovieCast(movieId);
    } catch (e) {
      _errorMessage = 'Failed to load cast.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:movie_app/models/tv_model.dart';
import 'package:movie_app/services/tmdb_api_service.dart';


class TvProvider extends ChangeNotifier {
  TvProvider(this._api);

  final TmdbApiService _api;

  List<TvModel> _tvSeries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TvModel> get tvSeries => List.unmodifiable(_tvSeries);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPopularTvSeries({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_tvSeries.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tvSeries = await _api.getPopularTvSeries();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<TvModel> fetchTvDetails(int id) {
    return _api.getTvDetails(id);
  }
}

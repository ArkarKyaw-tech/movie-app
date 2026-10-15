// {
//       "adult": false,
//       "backdrop_path": "/uFDlUMdp3NoXhnveAfgSpty8vBy.jpg",
//       "genre_ids": [
//         10767
//       ],
//       "id": 108188,
//       "origin_country": [
//         "AT"
//       ],
//       "original_language": "de",
//       "original_name": "Barbara Karlich – Talk um 4",
//       "overview": "A talk show produced by ORF since 1999 and broadcast on ORF 2.",
//       "popularity": 394.1134,
//       "poster_path": "/1NAVqNAKXbFbBzl9P52boCOUACJ.jpg",
//       "first_air_date": "1999-10-27",
//       "softcore": false,
//       "name": "Barbara Karlich – Talk um 4",
//       "vote_average": 4.5,
//       "vote_count": 4
//     }

class TvModel {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String name;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;

  const TvModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List? ?? [])
          .whereType<num>()
          .map((id) => id.toInt())
          .toList(),
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      originalLanguage: json['original_language'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      posterPath: json['poster_path'] as String?,
      firstAirDate: json['first_air_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }
}

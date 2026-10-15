// {
//       "adult": false,
//       "backdrop_path": "/4tjxYg2AbOzzG9G1YuiT2NzYhlH.jpg",
//       "genre_ids": [
//         878,
//         28,
//         12
//       ],
//       "id": 969681,
//       "title": "Spider-Man: Brand New Day",
//       "original_language": "en",
//       "original_title": "Spider-Man: Brand New Day",
//       "overview": "Fighting crime full-time as Spider-Man in a world that doesn't remember him—and the pressure of seeing his old friends move on without him—sparks a change in Peter Parker he may not have the power to control. But that transformation might also be the only thing that can stop a shocking new threat to the city and those he loves - a powerful villain no one can even see.",
//       "popularity": 986.0191,
//       "poster_path": "/bjiS5ipwxb9JFy3XRRN4OAilSeX.jpg",
//       "release_date": "2026-07-29",
//       "softcore": false,
//       "video": false,
//       "vote_average": 8.424,
//       "vote_count": 5051
//     },

class MovieModel {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  const MovieModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      adult: json['adult'] as bool? ?? false,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: (json['genre_ids'] as List? ?? [])
          .whereType<num>()
          .map((id) => id.toInt())
          .toList(),
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Unknown',
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      video: json['video'] as bool? ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }
}

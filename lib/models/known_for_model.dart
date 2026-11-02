// {
//       "adult": false,
//       "backdrop_path": "/5ORnbDn0np8z2DzReM5WFKlbxsY.jpg",
//       "genre_ids": [
//         99
//       ],
//       "id": 97400,
//       "title": "The Sweatbox",
//       "original_language": "en",
//       "original_title": "The Sweatbox",
//       "overview": "Trudie Styler, a documentarian, had been allowed to film the production of 'Kingdom of the Sun'/'The Emperor's New Groove' as part of the deal that originally brought her husband Sting to the project. As a result, Styler recorded much of the struggle, controversy, and troubles that went into making the picture on film (including when producer Fullmer called Sting to inform the pop star that his songs were being deleted from the film). Styler's completed documentary, The Sweatbox, premiered at the Toronto Film Festival on September 13, 2002. Disney owns the rights to the documentary and has not released it on home video or DVD.",
//       "popularity": 1.774,
//       "poster_path": "/oAHBWF4RitZTSIUmDIfIdaSjvQb.jpg",
//       "release_date": "2002-09-13",
//       "softcore": false,
//       "video": false,
//       "vote_average": 7.0,
//       "vote_count": 32,
//       "character": "Self",
//       "credit_id": "6271fb65c74eba0f0f0d3ac3",
//       "order": 15,
//       "media_type": "movie"
//     }

class KnownForModel {
  final int id;
  final String title;
  final String mediatype;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;
  final String character;

  KnownForModel({
    required this.id,
    required this.title,
    required this.mediatype,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.character,
  });

  factory KnownForModel.formJson(Map<String, dynamic> json) {
    return KnownForModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? json['name'] ?? 'Unknow title').toString(),
      mediatype: json['media_type'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      character: json['character'] as String? ?? '',
    );
  }

  String? get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return null;
    }
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }
}

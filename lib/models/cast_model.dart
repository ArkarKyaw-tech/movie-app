// {
//       "adult": false,
//       "gender": 2,
//       "id": 2,
//       "known_for_department": "Acting",
//       "name": "Mark Hamill",
//       "original_name": "Mark Hamill",
//       "popularity": 4.8779,
//       "profile_path": "/zMQ93JTLW8KxusKhOlHFZhih3YQ.jpg",
//       "cast_id": 3,
//       "character": "Luke Skywalker",
//       "credit_id": "52fe420dc3a36847f8000441",
//       "order": 0
//     }

class CastModel {
  final int id;
  final String name;
  final String? profilePath;
  final String character;
  final int order;

  CastModel({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,

    required this.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String? ?? '',
      character: json['character'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 999,
    );
  }

  String? get profileUrl {
    if (profilePath == null || profilePath!.isEmpty) {
      return null;
    }
    return "https://image.tmdb.org/t/p/w500$profilePath";
  }
}

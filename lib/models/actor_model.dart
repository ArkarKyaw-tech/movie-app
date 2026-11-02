// {
//   "adult": false,
//   "also_known_as": [
//     "Dave Reynolds",
//     "David F. Reynolds"
//   ],
//   "biography": "Dave began his writing career in 1993 as one of the original writers on NBC's \"Late Night With Conan O'Brien.\" After more than 400 shows, Dave moved to Los Angeles in 1995 and landed a job at Walt Disney Feature Animation in the movie \"Tarzan.\" It was at this time that he met a little-known animation studio called Pixar, who asked him to help develop his second feature, (Toy Story would be released later that year) “A Bug's Life \". This led to a contract with the studio and for the next six years he worked on almost every Disney Pixar animation or production film. Including the script for \"The Emperor's New Groove\" as well as co-written 'Finding Nemo'. He was nominated for an Oscar and BAFTA for Best Original Screenplay for Nemo, as well as a BAFTA for New Groove.",
//   "birthday": "1962-02-17",
//   "deathday": null,
//   "gender": 2,
//   "homepage": null,
//   "id": 11,
//   "imdb_id": "nm0721675",
//   "known_for_department": "Writing",
//   "name": "David Reynolds",
//   "place_of_birth": null,
//   "popularity": 1.1543,
//   "profile_path": null
// }

class ActorModel {
  final int id;
  final String biography;
  final String? birthday;
  final String knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;

  ActorModel({
    required this.id,
    required this.biography,
    required this.birthday,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      biography: json['biography'] as String? ?? '',
      birthday: json['birthday'] as String? ?? 'Date',
      knownForDepartment: json['known_for_department'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknow',
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profilePath'] as String?,
    );
  }

  String? get profileUrl {
    if (profilePath == null || profilePath!.isEmpty) {
      return null;
    }
    return "https://image.tmdb.org/t/p/w500$profilePath";
  }
}

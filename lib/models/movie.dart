class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String? releaseDate;
  final int? runtime;
  final List<String> genres;
  final List<Cast> cast;
  final List<Video> videos;
  String? trailerUrl;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.cast = const [],
    this.videos = const [],
    this.trailerUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
    );
  }

  factory Movie.fromDetailJson(Map<String, dynamic> json) {
    List<String> genreList = (json['genres'] as List? ?? [])
        .map((genre) => genre['name'] as String? ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    List<Cast> castList = (json['credits']?['cast'] as List? ?? [])
        .map((cast) => Cast.fromJson(cast))
        .take(10)
        .toList();

    List<Video> videoList = (json['videos']?['results'] as List? ?? [])
        .map((video) => Video.fromJson(video))
        .where((video) => video.site == 'YouTube')
        .toList();

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      genres: genreList,
      cast: castList,
      videos: videoList,
    );
  }
}

class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  Cast({required this.id, required this.name, required this.character, this.profilePath});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      character: json['character'] ?? 'Unknown',
      profilePath: json['profile_path'],
    );
  }
}

class Video {
  final String key;
  final String name;
  final String site;
  final String type;

  Video({required this.key, required this.name, required this.site, required this.type});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
class TVShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: json['vote_average'].toDouble(),
    );
  }
}
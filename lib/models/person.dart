
import 'movie.dart';
import 'tv_show.dart';

class Person {
  final int id;
  final String name;
  final String profilePath;
  final String? biography;
  final List<Movie> movieCredits;
  final List<TVShow> tvCredits;

  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    this.biography,
    required this.movieCredits,
    required this.tvCredits,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    List<Movie> movies = (json['movie_credits']['cast'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();

    List<TVShow> shows = (json['tv_credits']['cast'] as List)
        .map((show) => TVShow.fromJson(show))
        .toList();

    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      biography: json['biography'],
      movieCredits: movies,
      tvCredits: shows,
    );
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/person.dart';
import 'package:movies/models/tv_show.dart';
import '../models/movie.dart';

class MovieRepository {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '001fcb3242ed7c49fe5883f0a9a8158b';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).take(10).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=en-US&append_to_response=credits,videos,similar'));

    if (response.statusCode == 200) {
      return Movie.fromDetailJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=en-US&query=$query&page=1&include_adult=true'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<Movie>> fetchMoviesByCategory(String category) async {
    // Implement category-based fetching
    throw UnimplementedError();
  }

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/trending/movie/week?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<TVShow>> getPopularTVShows() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/tv/popular?api_key=$_apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((show) => TVShow.fromJson(show)).toList();
    } else {
      throw Exception('Failed to load popular TV shows');
    }
  }

  Future<Person> getPersonDetails(int personId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/person/$personId?api_key=$_apiKey&language=en-US&append_to_response=movie_credits,tv_credits'));

    if (response.statusCode == 200) {
      return Person.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load person details');
    }
  }

  Future<List<Movie>> getMoviesWithTrailers() async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=en-US&page=1'));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        List<Movie> movies = results.map((json) => Movie.fromJson(json)).toList();

        List<Movie> moviesWithTrailers = [];
        for (var movie in movies) {
          final trailerKey = await getTrailerKey(movie.id);
          if (trailerKey != null) {
            movie.trailerUrl = trailerKey;
            moviesWithTrailers.add(movie);
          }
        }

        return moviesWithTrailers;
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<String?> getTrailerKey(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response for trailer: $data');  // Debug print
        final List<dynamic> results = data['results'];
        final trailer = results.firstWhere(
              (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );

        if (trailer != null) {
          print('Trailer key: ${trailer['key']}');  // Debug print
          return trailer['key'];
        }
      }
    } catch (e) {
      print('Error fetching trailer key: $e');
    }
    return null;
  }
}
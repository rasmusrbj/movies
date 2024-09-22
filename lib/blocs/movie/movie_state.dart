// movie_state.dart
import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int currentIndex;
  final List<Movie> savedMovies;

  const MovieLoaded({
    required this.movies,
    required this.currentIndex,
    required this.savedMovies,
  });

  @override
  List<Object> get props => [movies, currentIndex, savedMovies];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}
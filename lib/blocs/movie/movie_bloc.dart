// movie_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/models/movie.dart';
import '../../repositories/movie_repository.dart';

import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc({required this.repository}) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
    on<SearchMovies>(_onSearchMovies);
    on<SelectCategory>(_onSelectCategory);
  }

  void _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await repository.fetchMovies();
      emit(MovieLoaded(movies: movies, currentIndex: 0, savedMovies: []));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void _onSwipeLeft(SwipeLeft event, Emitter<MovieState> emit) {
    if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;
      if (currentState.currentIndex < currentState.movies.length - 1) {
        emit(MovieLoaded(
          movies: currentState.movies,
          currentIndex: currentState.currentIndex + 1,
          savedMovies: currentState.savedMovies,
        ));
      }
    }
  }

  void _onSwipeRight(SwipeRight event, Emitter<MovieState> emit) {
    if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;
      if (currentState.currentIndex < currentState.movies.length - 1) {
        final savedMovies = List<Movie>.from(currentState.savedMovies)
          ..add(currentState.movies[currentState.currentIndex]);
        emit(MovieLoaded(
          movies: currentState.movies,
          currentIndex: currentState.currentIndex + 1,
          savedMovies: savedMovies,
        ));
      }
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    // Implement search logic
  }

  void _onSelectCategory(SelectCategory event, Emitter<MovieState> emit) async {
    // Implement category selection logic
  }
}
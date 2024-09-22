import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie.dart';
import '../../repositories/movie_repository.dart';

// Events
abstract class TrailerEvent {}

class LoadTrailers extends TrailerEvent {}

// States
abstract class TrailerState {}

class TrailerInitial extends TrailerState {}

class TrailerLoading extends TrailerState {}

class TrailerLoaded extends TrailerState {
  final List<Movie> movies;

  TrailerLoaded(this.movies);
}

class TrailerError extends TrailerState {
  final String message;

  TrailerError(this.message);
}

// BLoC
class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final MovieRepository repository;

  TrailerBloc({required this.repository}) : super(TrailerInitial()) {
    on<LoadTrailers>(_onLoadTrailers);
  }

  Future<void> _onLoadTrailers(LoadTrailers event, Emitter<TrailerState> emit) async {
    emit(TrailerLoading());
    try {
      final movies = await repository.getMoviesWithTrailers();
      emit(TrailerLoaded(movies));
    } catch (e) {
      emit(TrailerError('Failed to load trailers: $e'));
    }
  }
}
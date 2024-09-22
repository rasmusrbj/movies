// movie_event.dart
import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {}

class SwipeLeft extends MovieEvent {}

class SwipeRight extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object> get props => [query];
}

class SelectCategory extends MovieEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object> get props => [category];
}
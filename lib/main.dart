import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/blocs/movie/movie_event.dart';
import 'repositories/movie_repository.dart';
import 'blocs/movie/movie_bloc.dart';
import 'screens/main_tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MovieRepository repository = MovieRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (context) => MovieBloc(repository: repository)..add(LoadMovies()),
          ),
        ],
        child: CupertinoApp(
          title: 'Movie Swipe App',
          theme: CupertinoThemeData(brightness: Brightness.light),
          home: MainTabScreen(),
        ),
      ),
    );
  }
}
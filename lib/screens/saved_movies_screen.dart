import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_state.dart';
import '../models/movie.dart';

class SavedMoviesScreen extends StatefulWidget {
  @override
  _SavedMoviesScreenState createState() => _SavedMoviesScreenState();
}

class _SavedMoviesScreenState extends State<SavedMoviesScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Saved Movies'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Icon(
            CupertinoIcons.bookmark_fill,
            size: 22,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoaded) {
                    return _buildMovieList(state.savedMovies);
                  }
                  return const Center(child: CupertinoActivityIndicator());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        color: CupertinoColors.systemGrey5,
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.bookmark_solid,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Save',
                              style: TextStyle(
                                color: CupertinoColors.darkBackgroundGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          print('save');
                        },
                      ),
                      const SizedBox(width: 16),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 40),
                        color: CupertinoColors.darkBackgroundGray,
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.arrowshape_turn_up_right_fill,
                              color: CupertinoColors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          print('save');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (_isGridView) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: movies.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return _buildMoviePoster(movies[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _buildMovieListTile(movies[index]);
        },
      );
    }
  }

  Widget _buildMoviePoster(Movie movie) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMovieListTile(Movie movie) {
    return CupertinoListTile(
      leading: _buildMoviePoster(movie),
      title: Text(movie.title),
      subtitle: Text(movie.releaseDate ?? 'Unknown release date'),
    );
  }
}

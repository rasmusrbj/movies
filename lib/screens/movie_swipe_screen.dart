import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movies/repositories/movie_repository.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:movies/screens/saved_movies_screen.dart';
import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../blocs/movie/movie_state.dart';
import '../widgets/movie_swipe_card.dart';
import '../models/movie.dart';

class MovieSwipeScreen extends StatefulWidget {
  @override
  _MovieSwipeScreenState createState() => _MovieSwipeScreenState();
}

class _MovieSwipeScreenState extends State<MovieSwipeScreen> {
  late CardSwiperController _cardController;

  @override
  void initState() {
    super.initState();
    _cardController = CardSwiperController();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _navigateToMovieDetails(Movie movie) async {
    HapticFeedback.mediumImpact();
    final movieDetails = await MovieRepository().getMovieDetails(movie.id);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movieDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Explore'),
        trailing: CupertinoButton(
          child: Icon(
            CupertinoIcons.heart,
            color: CupertinoColors.darkBackgroundGray,
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SavedMoviesScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial) {
              context.read<MovieBloc>().add(LoadMovies());
              return Center(child: CupertinoActivityIndicator());
            } else if (state is MovieLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is MovieLoaded) {
              List<Movie> moviesToShow =
                  state.movies.skip(state.currentIndex).toList();
              return Column(
                children: [
                  Expanded(
                    child: moviesToShow.isNotEmpty
                        ? CardSwiper(
                            controller: _cardController,
                            cardsCount: moviesToShow.length,
                            cardBuilder: (context, index, _, __) {
                              return MovieSwipeCard(
                                movie: moviesToShow[index],
                                onTap: () => _navigateToMovieDetails(
                                    moviesToShow[index]),
                              );
                            },
                            onSwipe: _handleSwipe,
                            numberOfCardsDisplayed: 3,
                          )
                        : Center(child: Text('No more movies to show')),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: CupertinoIcons.xmark,
                          color: CupertinoColors.systemRed,
                          onPressed: () =>
                              _cardController.swipe(CardSwiperDirection.left),
                        ),
                        _buildActionButton(
                            icon: CupertinoIcons.heart_fill,
                            color: CupertinoColors.systemGreen,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              _cardController.swipe(CardSwiperDirection.right);
                            }),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }

  bool _handleSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right) {
      context.read<MovieBloc>().add(SwipeRight());
    } else if (direction == CardSwiperDirection.left) {
      context.read<MovieBloc>().add(SwipeLeft());
    }
    return true;
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(12),
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: Icon(icon, size: 30, color: CupertinoColors.white),
    );
  }
}

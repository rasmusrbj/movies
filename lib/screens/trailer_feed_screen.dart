import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/repositories/movie_repository.dart';
import '../blocs/trailer/trailer_bloc.dart';
import '../widgets/trailer_player.dart';

class TrailerFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrailerBloc(repository: context.read<MovieRepository>())..add(LoadTrailers()),
      child: TrailerFeedView(),
    );
  }
}

class TrailerFeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: BlocBuilder<TrailerBloc, TrailerState>(
          builder: (context, state) {
            if (state is TrailerInitial || state is TrailerLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is TrailerLoaded) {
              final moviesWithTrailers = state.movies.where((movie) => movie.trailerUrl != null && movie.trailerUrl!.isNotEmpty).toList();
              return moviesWithTrailers.isEmpty
                  ? const Center(child: Text('No trailers available'))
                  : PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: moviesWithTrailers.length,
                itemBuilder: (context, index) {
                  return TrailerPlayer(movie: moviesWithTrailers[index]);
                },
              );
            } else if (state is TrailerError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
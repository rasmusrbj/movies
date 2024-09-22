import 'package:flutter/cupertino.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  SearchResultsScreen({required this.searchQuery});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Movie>> searchResults;
  final MovieRepository repository = MovieRepository();

  @override
  void initState() {
    super.initState();
    searchResults = repository.searchMovies(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Search Results'),
      ),
      child: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: searchResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Movie movie = snapshot.data![index];
                  return CupertinoListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie.title),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(CupertinoIcons.right_chevron),
                      onPressed: () {
                        // Navigate to movie details screen
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:movies/screens/movie_details_screen.dart';
import '../models/category.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'search_results_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Category> categories = [
    Category(name: 'Action', color: Color(0xFFFFA000), icon: CupertinoIcons.flame),
    Category(name: 'Comedy', color: Color(0xFF64B5F6), icon: CupertinoIcons.smiley),
    Category(name: 'Drama', color: Color(0xFF4CAF50), icon: CupertinoIcons.thermometer),
    Category(name: 'Sci-Fi', color: Color(0xFF9C27B0), icon: CupertinoIcons.rocket),
    Category(name: 'Horror', color: Color(0xFFE91E63), icon: CupertinoIcons.alarm),
    Category(name: 'Romance', color: Color(0xFFF44336), icon: CupertinoIcons.heart),
    Category(name: 'Thriller', color: Color(0xFF795548), icon: CupertinoIcons.exclamationmark_triangle),
    Category(name: 'Animation', color: Color(0xFF00BCD4), icon: CupertinoIcons.tv),
  ];

  late Future<List<Movie>> _popularMovies;

  @override
  void initState() {
    super.initState();
    _popularMovies = MovieRepository().getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  placeholder: 'Search movies',
                  onSubmitted: (String value) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SearchResultsScreen(searchQuery: value),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Popular This Week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: FutureBuilder<List<Movie>>(
                  future: _popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final movie = snapshot.data![index];
                          return GestureDetector(
                              onTap: () async {
                            final movieDetails = await MovieRepository().getMovieDetails(movie.id);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => MovieDetailsScreen(movie: movieDetails),
                              ),
                            );
                          },
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: index == 9 ? 16 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      movie.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildCategoryCard(categories[index]),
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(-5.5, -5.5),
            color: CupertinoColors.black.withOpacity(0.2)
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 16,
            child: Text(
              category.name,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              category.icon,
              size: 80,
              color: const Color.fromRGBO(255, 255, 255, 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
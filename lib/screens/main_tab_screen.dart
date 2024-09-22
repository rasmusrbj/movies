import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/screens/trailer_feed_screen.dart';
import 'movie_swipe_screen.dart';
import 'categories_screen.dart';
import '../blocs/tab/tab_bloc.dart';

class MainTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBloc(),
      child: BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              backgroundColor: state.currentIndex == 1 ? CupertinoColors.black : null,
              activeColor: state.currentIndex == 1 ? CupertinoColors.white : CupertinoColors.black,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.film, size: 22),
                  activeIcon: Icon(CupertinoIcons.film_fill, size: 22),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.play_rectangle, size: 22),
                  activeIcon: Icon(CupertinoIcons.play_rectangle_fill, size: 22),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_grid_2x2, size: 22),
                  activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill, size: 22),
                ),
              ],
              onTap: (index) {
                context.read<TabBloc>().add(TabChanged(index));
              },
              currentIndex: state.currentIndex,
            ),
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(builder: (context) => MovieSwipeScreen());
                case 1:
                  return CupertinoTabView(builder: (context) => TrailerFeedScreen());
                case 2:
                  return CupertinoTabView(builder: (context) => CategoriesScreen());
                default:
                  return CupertinoTabView(builder: (context) => MovieSwipeScreen());
              }
            },
          );
        },
      ),
    );
  }
}
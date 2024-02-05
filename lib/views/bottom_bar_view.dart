import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/views/favourites_view.dart';
import 'package:movies/views/movies_view.dart';
import 'package:movies/views/profile_view.dart';
import 'package:movies/views/search_view.dart';

class MoviesTabBar extends StatefulWidget {
  const MoviesTabBar({super.key});

  @override
  State<MoviesTabBar> createState() => _MoviesTabBarState();
}

class _MoviesTabBarState extends State<MoviesTabBar> {
  int _selectedIndex = 0;

  static const List<Widget> _tabBarWidgets = [
    MoviesView(),
    FavouritesView(),
    SearchView(),
    ProfileView(),
  ];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabBarWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
            ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: CupertinoColors.systemCyan,
        currentIndex: _selectedIndex,
        selectedItemColor: CupertinoColors.label,
        selectedFontSize: 14,
        unselectedItemColor: CupertinoColors.secondaryLabel,
        unselectedFontSize: 14,
        showUnselectedLabels: true,
        onTap: _itemTapped,
      ),
    );
  }
}

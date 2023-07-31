import 'package:a_tour_action/screens/favorite_screen.dart';
import 'package:a_tour_action/screens/home_screen.dart';
import 'package:a_tour_action/screens/map_screen.dart';
import 'package:flutter/material.dart';
import '../screens/menu_screen.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      shape: const CircularNotchedRectangle(),
      elevation: 50,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.map_outlined,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

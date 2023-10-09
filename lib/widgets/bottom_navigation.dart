import 'package:a_tour_action/screens/game_screen.dart';
import 'package:a_tour_action/screens/places_screen.dart';
import 'package:a_tour_action/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../screens/menu_screen.dart';

class BottomNavigation extends StatelessWidget {
  final bool homeFill;
  final bool gameFill;
  final bool placeFill;
  final bool menuFill;
  final ValueChanged<bool>? onGameFillChanged;

  const BottomNavigation(
      {super.key,
      required this.placeFill,
      required this.homeFill,
      required this.gameFill,
      required this.menuFill,
      this.onGameFillChanged,});

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
            icon: Icon(homeFill ? Icons.home_filled : Icons.home_outlined,
                color: Color.fromARGB(255, 70, 159, 209)),
            onPressed: () {
              if (!homeFill) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              gameFill ? Icons.gamepad : Icons.gamepad_outlined,
              color: Color.fromARGB(255, 70, 159, 209),
            ),
            onPressed: () {
              if (!gameFill) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              placeFill ? Icons.place : Icons.place_outlined,
              color: Color.fromARGB(255, 70, 159, 209),
            ),
            onPressed: () {
              if (!placeFill) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlacesScreen(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              menuFill ? Icons.menu_open : Icons.menu_outlined,
              color: Color.fromARGB(255, 70, 159, 209),
            ),
            onPressed: () {
              if (!menuFill) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

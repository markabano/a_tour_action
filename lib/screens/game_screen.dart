import 'package:a_tour_action/widgets/bottom_navigation.dart';
import 'package:a_tour_action/widgets/camera.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/game_logo_atouraction.png',
                            height: MediaQuery.of(context).size.width * .3,
                          ),
                          const SizedBox( height: 25,),
                          TextButton(onPressed: (){}, child: const Text('Learn About Historical Sites')),
                          TextButton(onPressed: (){}, child: const Text('Options')),
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: false, gameFill: true, placeFill: false, menuFill: false),
    );
  }
}

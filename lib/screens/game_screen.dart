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
                  color: const Color.fromRGBO(246, 245, 241, 1),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/game_logo_atouraction.png',
                            height: MediaQuery.of(context).size.width * 0.9,
                          ),
                          // const SizedBox( height: 15,),
                          ElevatedButton(onPressed: (){}, child: const Text('Take Quiz!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),),),
                          ElevatedButton(onPressed: (){}, child: const Text('Options',style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),),),
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

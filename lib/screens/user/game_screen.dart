import 'package:a_tour_action/screens/user/game%20tab/category_screen.dart';
import 'package:a_tour_action/screens/user/game%20tab/game_quiz_screen.dart';
import 'package:a_tour_action/widgets/bottom_navigation.dart';
import 'package:a_tour_action/widgets/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void playGameShowSound() async {
    await audioPlayer
        .play(AssetSource('audio/y2mate.com - The Game Show Theme Music.mp3'));
    setState(() {
      isPlaying = true;
    });
  }

  void stopGameShowSound() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playGameShowSound();
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Stop and release the audio player when the widget is disposed
    super.dispose();
  }

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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CategoryScreen()));
                            },
                            child: const Text(
                              'Take Quiz!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'Options',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
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
        homeFill: false,
        gameFill: true,
        placeFill: false,
        menuFill: false,
        onGameFillChanged: (bool newValue) {
          if (newValue) {
            // Play the game show sound when gameFill is set to true
            playGameShowSound();
          } else {
            stopGameShowSound();
          }
        },
      ),
    );
  }
}

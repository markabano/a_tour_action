import 'package:flutter/material.dart';

class GameQuizScreen extends StatefulWidget {
  const GameQuizScreen({super.key});

  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.9,
                color: Colors.blueAccent,
              ),
            ],
            ),
        ),),
    );
  }
}
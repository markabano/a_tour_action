import 'package:a_tour_action/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ATourAction());
}

class ATourAction extends StatelessWidget {
  const ATourAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

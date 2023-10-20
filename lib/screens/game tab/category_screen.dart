import 'package:a_tour_action/screens/game%20tab/game_quiz_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Category or Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ElevatedButton(
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameQuizScreen(), // Pass the selected category
                  ),
                );
              },
              child: const Text("Start Quiz"),
            ),
          ],
        ),
      ),
    );
  
  }
}
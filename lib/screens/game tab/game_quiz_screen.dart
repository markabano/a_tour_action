import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameQuizScreen extends StatefulWidget {
  const GameQuizScreen({super.key});

  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen> {
  List<Map<String, dynamic>> questions = []; // List to store the questions
  int currentQuestionIndex = 0; // Index of the current question
  String selectedAnswer = ""; // Store the selected answer

  @override
  void initState() {
    super.initState();
    // Replace 'multipleChoiceQuestions' with your Firestore collection name
    FirebaseFirestore.instance.collection('quizQuestions').get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        questions = querySnapshot.docs.map((doc) {
          return {
            'question': doc['question'],
            'options': doc['options'],
            'correctAnswer': doc['correctAnswer'],
          };
        }).toList();

        // questions.shuffle();
        setState(() {
          currentQuestionIndex = 0;
        });
      }
    });
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void showNextQuestion() {
    setState(() {
      selectedAnswer = "";
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                  ),
                height: MediaQuery.of(context).size.width * 0.9,
                
                child: Center(
                  child: Text(
                    questions.isNotEmpty && currentQuestionIndex < questions.length
                        ? questions[currentQuestionIndex]['question']
                        : "No more questions",
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              if (questions.isNotEmpty && currentQuestionIndex < questions.length)
                Column(
                  children: questions[currentQuestionIndex]['options'].map<Widget>((option) {
                    return ListTile(
                      title: Text(option),
                      leading: Radio(
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          selectAnswer(value);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15,),
              ElevatedButton(
                // showNextQuestion
                onPressed: (){},
                child: const Text("Next Question"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameQuizScreen extends StatefulWidget {
  const GameQuizScreen({super.key});

  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String selectedAnswer = "";
  bool isCorrectAnswer = false;

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
            'info': doc['info'], // Additional information related to the question
          };
        }).toList();

        questions.shuffle();
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
      isCorrectAnswer = false;
      currentQuestionIndex++;
    });
  }

  void checkAnswer() {
    if (selectedAnswer == questions[currentQuestionIndex]['correctAnswer']) {
      // User selected the correct answer
      setState(() {
        isCorrectAnswer = true;
      });
    } else {
      // User selected the wrong answer
      setState(() {
        isCorrectAnswer = false;
      });
    }
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.width * 0.6,
                
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                onPressed: () {
                  checkAnswer();
                },
                child: const Text("Submit Answer"),
              ),
              
              ElevatedButton(
                onPressed: showNextQuestion,
                child: const Text("Next Question"),
              ),
                ],
              ),
              if (selectedAnswer.isNotEmpty)
                isCorrectAnswer
                    ? Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "You got it right! Here's some information:\n\n${questions[currentQuestionIndex]['info']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                      ),
                    )
                    : Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Sorry, that's incorrect. Here's some information:\n\n${questions[currentQuestionIndex]['info']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

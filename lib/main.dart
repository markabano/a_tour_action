import 'package:a_tour_action/firebase_options.dart';
import 'package:a_tour_action/screens/user/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ATourAction());
}

class ATourAction extends StatelessWidget {
  const ATourAction({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(
            255, 70, 159, 209), // Set the primary color here
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

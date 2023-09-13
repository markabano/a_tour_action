import 'package:a_tour_action/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/customTextField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A Tour Action',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 50),
                const Icon(
                  Icons.app_registration_outlined,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                    controller: nameController,
                    hintText: 'Name',
                    icon: Icons.person,
                    obscureText: false),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.email,
                    obscureText: false),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: cpasswordController,
                    hintText: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: true),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('Login here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    //Check if password matches
    if (passwordController.text != cpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and Confirm Password must be same'),
        ),
      );
    }

    //Check if email is valid
    else if (!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
        ),
      );
    }

    //Create User
    else {
      //Register user
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) async {
        //Add user details to firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'name': nameController.text,
          'email': emailController.text,
          'uid': value.user!.uid,
        });

        //Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }).catchError(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        },
      );
    }
  }
}

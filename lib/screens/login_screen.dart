import 'package:a_tour_action/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/customTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: MediaQuery.of(context).size.width * .3,
                          ),
                          Text(
                            'A-TOUR-ACTION',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 70, 159, 209),
                            ),
                          ),
                         
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 30),

                          
                          SizedBox(
                            height: 55,
                            width: 250,
                            child: RichText
                            (
                              textAlign: TextAlign.center,
                              text: TextSpan(
                            text: 'By signing in you are agreeing to our ',
                            style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                            children: [
                              TextSpan(

text:  'Terms and Privacy Policy',

recognizer: TapGestureRecognizer()..onTap=() => null,

  
style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .blue, // You can change the color to make it stand out.
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ]
                          )),
                          ),
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
                          const SizedBox(height: 15),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password")),
                          ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Not a member yet?'),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                ),
                                child: const Text('Register here',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.asset(
                            'assets/images/image 11.jpg',
                            height: MediaQuery.of(context).size.width * .5,
                          ),
                          ClipPath(
                            clipper: ClipClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 70, 159, 209),
                              ),
                              height: 100,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    //show circular progress indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //hide circular progress indicator
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //hide circular progress indicator
      Navigator.pop(context);

      //Wrong Email
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('No user found for that email.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            );
          },
        );
      }

      //Wrong Password
      else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Wrong password provided for that user.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            );
          },
        );
      }

      //Wrong Email Format
      else if (e.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('The email address is badly formatted.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            );
          },
        );
      }
    }
  }
}

class ClipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0); // Move to the top-left corner
    path.lineTo(0, size.height); // Line to the bottom-left corner
    path.lineTo(size.width, size.height); // Line to the bottom-right corner
    path.lineTo(size.width, 0); // Line to the top-right corner
    path.quadraticBezierTo(size.width / 2, size.height / 1, 0, 0);

    path.close(); // Close the path to complete the clip shape

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

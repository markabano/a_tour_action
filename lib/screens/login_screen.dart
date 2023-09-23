import 'package:a_tour_action/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        child: SingleChildScrollView(
          child: Container(
            height: 725,
          // padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/image 11.jpg'),
              alignment: Alignment.bottomCenter,
              opacity: 0.8,
            ),
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Text(
                  'A Tour Action',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
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
                child: Column(
                  children: [
                  Text(
            'By signing in you are agreeing to our ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
                  ),
                  GestureDetector(
            onTap: () {
              // Handle the click event for "Terms and Privacy Policy" here.
              // You can use Navigator.push() to navigate to the terms and privacy policy page.
              // Example:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndPrivacyPolicyScreen()));
            },
            child: const Text(
              'Terms and Privacy Policy',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // You can change the color to make it stand out.
                decoration: TextDecoration.underline,
              ),
            ),
                  ),
                  ],
              ),
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
                TextButton(onPressed: (){}, 
                child: const Text("Forgot Password")
                ),
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
                          builder: (context) => const RegisterScreen(),
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
                const SizedBox(height: 6),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 200,
                        color: Colors.blue, 

                      child: ClipPath(
                        clipper: ClipClipper(),
                        child: Container(
                          width: 100,
                          height: 250,
                          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/image 11.jpg'),
              alignment: Alignment.bottomCenter,
              opacity: 0.8,
            ),
          ),
                        ),
                      ),
                    ),
  ]
                  ),
                ),
              ],
            ),
          ),
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

      Path path=Path();

      // path.lineTo(0, size.height);
      // path.lineTo(size.width, size.height);
      // path.quadraticBezierTo(0, size.height , 0, 0);
      path.moveTo(0, 0); // Move to the top-left corner
      path.lineTo(0, size.height / 2); // Line to the left side of the semi-circle
      path.quadraticBezierTo(
      size.width / 2, size.height, size.width, size.height / 2); // Create the upside-down semi-circle
      path.lineTo(size.width, 0); // Line to the top-right corner
      path.close(); // Close the path to complete the clip shape
      
      return path;
    }
  
    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  }

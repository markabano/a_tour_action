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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 745,
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
                ),
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

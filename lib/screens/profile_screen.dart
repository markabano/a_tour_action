import 'package:a_tour_action/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Save'),
                  content: const Text('Are you sure you want to save?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        updateUserData();
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    Text('Edit'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    nameController.text = userData.data()!['name'];
    emailController.text = userData.data()!['email'];
  }

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
        ),
      );
      return;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': nameController.text,
      });
      Navigator.pop(context);
    }

    if (passwordController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password does not match'),
          ),
        );
        return;
      } else {
        user.updatePassword(passwordController.text);
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ),
        );
      }
    }
  }
}

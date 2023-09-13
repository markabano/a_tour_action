import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';
import '../auth_page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String name = '';
  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 200,
              color: Colors.lightBlue[100],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: isLoaded
                    ? Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 100,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            GestureDetector(
              onTap: logout,
              child: const Card(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: false, mapFill: false, placeFill: false, menuFill: true),
    );
  }

  void logout() async {
    //Logout
    await FirebaseAuth.instance.signOut();

    //Go to Auth Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthPage(),
      ),
    );
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    name = userData.data()!['name'];

    setState(() {
      isLoaded = true;
    });
  }
}

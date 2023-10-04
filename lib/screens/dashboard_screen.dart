import 'package:a_tour_action/screens/upload_place_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String name = '';
  String email = '';
  String _imageUrl = '';
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
              Center(
                child: Text(
                  'DashBoard',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    isLoaded
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_imageUrl),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${name}'),
                        Text('Email: ${email}'),
                        Text('Verified: '),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Your Uploads'),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    10,
                    (index) => Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://picsum.photos/200/300',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Title'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPlaceScreen(),
              )),
          child: const Icon(Icons.add),
        ));
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    name = userData.data()!['name'];
    email = userData.data()!['email'];
    if (userData.data()?['imageUrl'] != null) {
      _imageUrl = userData.data()?['imageUrl'];
    } else {
      _imageUrl = '';
    }

    setState(() {
      isLoaded = true;
    });
  }

  Future<void> getUploads() async {
    final user = FirebaseAuth.instance.currentUser;
    final uploads = await FirebaseFirestore.instance
        .collection('places')
        .where('userId', isEqualTo: user!.uid)
        .get();
  }
}

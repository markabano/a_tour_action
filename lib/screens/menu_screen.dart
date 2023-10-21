import 'package:a_tour_action/screens/about.dart';
import 'package:a_tour_action/screens/dashboard_screen.dart';
import 'package:a_tour_action/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';
import '../auth_page.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key, this.isLoaded = false});
  bool isLoaded;
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String name = '';
  String _imageUrl = '';

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
              color: Color.fromARGB(255, 249, 249, 249),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: widget.isLoaded
                    ? Row(
                        children: [
                          Card(
                            elevation:
                                5, // Adjust the elevation to control the shadow depth
                            shape: CircleBorder(), // Make the card circular
                            child: Container(
                                width:
                                    100, // Set the width and height to control the size of the circular border
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width:
                                        3, // Adjust the width of the border as needed
                                  ),
                                ),
                                child: _imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius:
                                              48, // Adjust the radius to fit within the border
                                          backgroundImage: imageProvider,

                                          backgroundColor: Colors
                                              .transparent, // Set a transparent background color
                                          // child: _imageUrl.isEmpty
                                          //     ? Icon(
                                          //         Icons.person,
                                          //         size: 48,
                                          //       )
                                          //     : null,
                                        ),
                                        imageUrl: _imageUrl,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    // CircleAvatar(
                                    //   radius:
                                    //       48, // Adjust the radius to fit within the border
                                    //   backgroundImage: _imageUrl.isNotEmpty
                                    //       ? NetworkImage(_imageUrl)
                                    //       : null,
                                    //   backgroundColor: Colors
                                    //       .transparent, // Set a transparent background color
                                    //   child: _imageUrl.isEmpty
                                    //       ? Icon(
                                    //           Icons.person,
                                    //           size: 48,
                                    //         )
                                    //       : null, // Show the Icon only when _imageUrl is empty
                                    // ),

                                    : CircleAvatar(
                                        radius: 50,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      )),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
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
            Card(
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashBoardScreen(),
                  ),
                ),
                leading: const Icon(
                  Icons.dashboard,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
                title: const Text('Dashboard'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                ),
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
                title: const Text('Profile'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
                leading: Icon(
                  Icons.info,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
                title: const Text('About'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
              ),
            ),
            GestureDetector(
              onTap: logout,
              child: const Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 166, 0, 0),
                  ),
                  title: const Text('Logout'),
                  // trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: false, gameFill: false, placeFill: false, menuFill: true),
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
    if (userData.data()?['imageUrl'] != null) {
      _imageUrl = userData.data()?['imageUrl'];
    } else {
      _imageUrl = '';
    }

    setState(() {
      widget.isLoaded = true;
    });
  }
}

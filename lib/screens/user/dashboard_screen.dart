import 'dart:async';
// import 'package:a_tour_action/auth_page.dart';
// import 'package:a_tour_action/screens/place_info_screen.dart';
// import 'package:a_tour_action/screens/upload_place_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:a_tour_action/screens/user/place_info_screen.dart';
// import 'package:a_tour_action/screens/user/upload_place_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../auth_page.dart';
import '../place_info_screen.dart';
import 'upload_place_screen.dart';

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
  bool isVerified = false;

  var myPlaces = FirebaseFirestore.instance
      .collection('places')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  List places = [];

  final PageController _pageController = PageController(
    viewportFraction: 1.0,
    initialPage: 0,
  );
  int _currentPage = 0;
  Timer? _timer;

  StreamController<bool> _dataReadyController = StreamController<bool>();

  @override
  void initState() {
    super.initState();

    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    getUserData();

    // Listen to the StreamController to know when data is ready
    _dataReadyController.stream.listen((dataReady) {
      if (dataReady) {
        // Start the autoplay timer when data is ready
        _startAutoplay();
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is removed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DashBoard'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Expanded(
                      child: Row(
                        children: [
                          isLoaded
                              ?  Card(
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
                          ) :
                          CircleAvatar(
                                        radius: 50,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${name}'),
                              Text('Email: ${email}'),
                              Row(
                                children: [
                                  const Text('Verified: '),
                                  Icon(
                                    isVerified
                                        ? Icons.verified
                                        : Icons.verified_outlined,
                                    color: isVerified ? Colors.green : Colors.red,
                                  ),
                                  
                                ],
                              ),
                              isVerified
                                      ? const SizedBox.shrink()
                                      : TextButton(
                                          onPressed: verifyEmail,
                                          child: const Text('Click here to verify', textAlign: TextAlign.start,),
                                        ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  isVerified
                      ? const SizedBox.shrink()
                      : const Text(
                          'You need to verify your email first before you can upload places.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                  const Divider(
                    thickness: 3,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Your Uploads',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: myPlaces,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No data available');
                      }
          
                      places = snapshot.data!.docs; // List of documents
          
                      // Signal that data is ready
                      _dataReadyController.add(true);
          
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final placeDoc = places[index];
                            final placeData = placeDoc.data();
          
                            // Replace 'PlaceField' with the actual field name you want to display
                            final placeName = placeData['name'];
                            final placeImages = placeData['pictures'];
                            final placeId = placeData['id'];
          
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceInfoScreen(
                                    place: placeData,
                                  ),
                                ),
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: PageView.builder(
                                        itemCount: placeImages.length,
                                        controller: _pageController,
                                        itemBuilder: (context, imageIndex) {
                                          final imageUrl = placeImages[imageIndex];
                                          return Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(placeName),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UploadPlaceScreen(
                                                        editUploadedPlace:
                                                            placeData,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  deletePlaceWithPhotos(
                                                      placeId, placeName);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isVerified) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPlaceScreen(),
                  ));
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Email not verified'),
                      content: const Text(
                          'You need to verify your email first before you can upload places.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'))
                      ],
                    );
                  });
            }
          },
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

  Future<void> verifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user!.sendEmailVerification();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email sent'),
              content: Text(
                  'An email has been sent to ${user.email}. Please verify your email.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    },
                    child: const Text('OK'))
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.message!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }
  }

  Future<void> deletePlaceWithPhotos(int placeId, String placeName) async {
    try {
      // Query Firestore to get the place document
      final querySnapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('id', isEqualTo: placeId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final placeDoc = querySnapshot.docs.first;

        // Delete the place document from Firestore
        await placeDoc.reference.delete();

        // Delete associated photos from Firebase Storage
        final storage = FirebaseStorage.instance;
        final folderRefs = [
          storage.ref().child('places').child(placeName).child('images'),
          storage.ref().child('places').child(placeName).child('panorama'),
        ];

        for (final folderRef in folderRefs) {
          final ListResult result = await folderRef.listAll();
          for (final item in result.items) {
            await item.delete();
          }
        }
      } else {
        // Handle the case where the place document is not found
        print('Place document not found.');
      }

      // Place and photos are successfully deleted
    } catch (error) {
      // Handle any errors that occur during deletion
      print('Error deleting place and photos: $error');
      // You can show an error message to the user if needed.
    }
  }

  void _startAutoplay() {
    if (places.isNotEmpty) {
      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        // Calculate the next page based on the current page and places.length
        final nextPage = (_currentPage + 1) % 5;

        // Ensure that the PageController is attached to a PageView before animating
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }

        // Update the current page
        _currentPage = nextPage;
      });
    }
  }
}

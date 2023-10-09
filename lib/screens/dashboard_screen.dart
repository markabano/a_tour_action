import 'dart:async';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:a_tour_action/screens/upload_place_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
          child: Column(
            children: [
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
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: myPlaces,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
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

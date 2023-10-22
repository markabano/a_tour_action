import 'package:a_tour_action/screens/admin/admin_place_info_screen.dart';
import 'package:a_tour_action/widgets/adminDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  var firebasePlaces = FirebaseFirestore.instance
      .collection('places')
      .where('status', isEqualTo: 'pending')
      .orderBy('name')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              const Text('Places To Review For Approval'),
              Expanded(
                  child: StreamBuilder(
                stream: firebasePlaces,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while data is loading
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                        'No data available'); // Handle the case when there's no data
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot place = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdminPlaceInfoScreen(place: place.data()),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  imageUrl: place['pictures'][0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1, // Limit to one line
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        place['description'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Limit to two lines
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      deniedPlace(place['name']);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    approvePlace(place['name']);
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              )),
            ],
          ),
        ),
      ),
      drawer: AdminDrawer(),
    );
  }

  Future<void> approvePlace(String placeName) async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(placeName)
          .update({'status': 'approved'});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deniedPlace(String placeName) async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(placeName)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}

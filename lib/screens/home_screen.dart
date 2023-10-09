import 'dart:convert';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:a_tour_action/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:carousel_slider/carousel_slider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int temperature = 0;
  int humidity = 0;
  int windSpeed = 0;
  int pressure = 0;
  String main = '';
  String description = '';
  String icon = '';
  String name = '';
  String _imageUrl = '';
  bool isLoading = false;
  bool isLoaded = false;

  var favorites = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('favorites')
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      )),
                  child: Row(
                    children: [
                      Card(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(
                                  255, 255, 255, 255), // White border color
                              width: 3.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                              // backgroundColor:
                              //     const Color.fromARGB(255, 255, 255, 255),
                              child: _imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                      ),
                                      imageUrl: _imageUrl,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      child: Icon(
                                        Icons.person,
                                      ),
                                    )),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello!",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(25.0), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(25.0), // Adjust the radius as needed
                  ),
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
                width: double.infinity,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isLoading == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Baguio City',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$temperature°C',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  main,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      getWeather();
                                    },
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    )),
                                Image.network(
                                  'https://openweathermap.org/img/wn/$icon.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.water_drop,
                                        color: Colors.white),
                                    Text(
                                      '$humidity%',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Favorites', style: TextStyle(fontSize: 20)),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: StreamBuilder(
                  stream: favorites,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis
                            .horizontal, // Set the scroll direction to horizontal
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot place = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceInfoScreen(
                                    place: place['data'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4, // Add shadow to the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width * .78,
                                // height: MediaQuery.of(context).size.height * .10,
                                // height: 300,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              imageUrl: place['data']
                                                  ['pictures'][0],
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: const Color.fromARGB(
                                                      255, 70, 159, 209),
                                                  value: progress.progress,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl: place['data']
                                                    ['pictures'][1],
                                                height: 70,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: const Color.fromARGB(
                                                        255, 70, 159, 209),
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl: place['data']
                                                    ['pictures'][2],
                                                height: 70,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: const Color.fromARGB(
                                                        255, 70, 159, 209),
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        place['data']['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child:
                    Text('Featured Locations', style: TextStyle(fontSize: 20)),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: StreamBuilder(
                  stream: favorites,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis
                            .horizontal, // Set the scroll direction to horizontal
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot place = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceInfoScreen(
                                    place: place['data'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4, // Add shadow to the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width * .78,
                                // height: MediaQuery.of(context).size.height * .10,
                                // height: 300,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              imageUrl: place['data']
                                                  ['pictures'][0],
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: const Color.fromARGB(
                                                      255, 70, 159, 209),
                                                  value: progress.progress,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  imageUrl: place['data']
                                                      ['pictures'][1],
                                                  height: 70,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              70,
                                                              159,
                                                              209),
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  imageUrl: place['data']
                                                      ['pictures'][2],
                                                  height: 70,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              70,
                                                              159,
                                                              209),
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                                // Image.network(
                                                //   place['data']['pictures'][2],
                                                //   height: 70,
                                                //   width: 100,
                                                //   fit: BoxFit.cover,
                                                // ),
                                                ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        place['data']['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 70, 159, 209),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: true, gameFill: false, placeFill: false, menuFill: false),
    );
  }

  Future<void> getWeather() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Baguio&units=metric&appid=4d591aa6aa6d1cb8dbeca8fff1a71efd');
    var response = await http.get(url);
    var decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      temperature = decodedResponse['main']['temp'].round();
      humidity = decodedResponse['main']['humidity'];
      windSpeed = decodedResponse['wind']['speed'].round();
      pressure = decodedResponse['main']['pressure'].round();
      description = decodedResponse['weather'][0]['description'];
      main = decodedResponse['weather'][0]['main'];
      icon = decodedResponse['weather'][0]['icon'];

      setState(() {
        isLoading = true;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
      isLoaded = true;
    });
  }
}

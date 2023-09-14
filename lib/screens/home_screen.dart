import 'dart:convert';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(
                            255, 206, 206, 206), // White border color
                        width: 3.0, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Icon(Icons.person),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning!",
                          style: TextStyle(color: Colors.grey),
                        ),
                        //  SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(
                              "Hi,",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              " " + "Badua",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              // color: Colors.amber,
              height: 90,
              padding: const EdgeInsets.all(20),
              child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ))),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(25.0), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(25.0), // Adjust the radius as needed
                ),
                color: const Color.fromARGB(255, 70, 159, 209),
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
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            StreamBuilder(
              stream: favorites,
              builder: (context, snapshot) {
                if (snapshot.data?.docs.length != 0) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Favorites",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                return Text('');
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: favorites,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis
                          .horizontal, // Set the scroll direction to horizontal
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot place = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
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
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Larger image on the left
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 8, 8),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              place['data']['pictures'][0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Two stacked images on the right
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 4),
                                              child: Image.network(
                                                place['data']['pictures'][1],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 4, 0, 4),
                                              child: Image.network(
                                                place['data']['pictures'][2],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),

                                        //4-5
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 4),
                                              child: Image.network(
                                                place['data']['pictures'][3],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 4, 0, 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Image.network(
                                                place['data']['pictures'][4],
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        18, 10, 10, 10),
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: true, mapFill: false, placeFill: false, menuFill: false),
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
}

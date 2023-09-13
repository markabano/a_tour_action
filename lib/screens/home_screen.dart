import 'dart:convert';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';
import 'package:http/http.dart' as http;

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
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue,
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
            const SizedBox(height: 20),
            const Text(
              "Favorites",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('favorites')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
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
                                        )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.blue[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      place['data']['pictures'][0],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      place['data']['name'],
                                      textAlign: TextAlign.left,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          snapshot.data!.docs.removeAt(index);
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('favorites')
                                            .doc(place.id)
                                            .delete();
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
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

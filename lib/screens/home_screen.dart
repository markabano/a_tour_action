import 'dart:convert';
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

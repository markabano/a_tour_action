import 'dart:convert';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<String> places = [];
  List placeToPass = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
            if (isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaceInfoScreen(place: placeToPass[index]),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          leading: Image.network(
                            placeToPass[index]["pictures"][0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(places[index]),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: false, mapFill: false, placeFill: true, menuFill: false),
    );
  }

  Future<void> getPlaces() async {
    var response = await DefaultAssetBundle.of(context)
        .loadString('assets/json/places.json');
    var decodedResponse = jsonDecode(response);
    for (var eachplace in decodedResponse["data"]) {
      places.add(eachplace["name"]);
      placeToPass.add(eachplace);

      setState(() {
        isLoading = true;
      });
    }
  }
}

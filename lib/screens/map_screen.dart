import 'dart:convert';
import 'package:a_tour_action/screens/place_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/camera.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = [];
  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    getPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoaded == false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(16.412544135267673, 120.59299185966717),
                  zoom: 15,
                ),
                markers: _markers.toSet(),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
      bottomNavigationBar: BottomNavigation(
          homeFill: false, mapFill: true, favFill: false, menuFill: false),
    );
  }

  Future<void> getPlaces() async {
    var response = await DefaultAssetBundle.of(context)
        .loadString('assets/json/places.json');
    var decodedResponse = jsonDecode(response);
    for (var eachplace in decodedResponse["data"]) {
      var marker = Marker(
        markerId: MarkerId(eachplace["name"]),
        position: LatLng(eachplace["lat"], eachplace["lng"]),
        infoWindow: InfoWindow(
          title: eachplace["name"],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceInfoScreen(
                      place: eachplace,
                    )),
          ),
        ),
      );

      _markers.add(marker);
      setState(() {
        isLoaded = true;
      });
    }
  }
}

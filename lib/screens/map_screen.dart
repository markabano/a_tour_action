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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(16.412544135267673, 120.59299185966717),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId('Historical Core'),
              position: LatLng(16.399222184994507, 120.61753165693972),
              infoWindow: InfoWindow(
                title: 'Historical Core',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Historical Core',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId(
                  'Heritage Hill and Nature Park Garden (Old Diplomat Hotel)'),
              position: LatLng(16.40399209758665, 120.58725441124297),
              infoWindow: InfoWindow(
                  title:
                      'Heritage Hill and Nature Park Garden (Old Diplomat Hotel)'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PlaceInfoScreen(
                          placeName: 'Heritage Hill and Nature Park Garden',
                        )),
              ),
            ),
            Marker(
              markerId: MarkerId('Bell House'),
              position: LatLng(16.399331793443256, 120.61905615726636),
              infoWindow: InfoWindow(
                title: 'Bell House',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Bell House',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Laperal White House'),
              position: LatLng(16.411241168566324, 120.6054291284311),
              infoWindow: InfoWindow(
                title: 'Laperal White House',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Laperal White House',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Cemetery Of Negativism'),
              position: LatLng(16.399620369530364, 120.61764716891348),
              infoWindow: InfoWindow(
                title: 'Cemetery Of Negativism',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Cemetery Of Negativism',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Emilio F. Aguinaldo Museum'),
              position: LatLng(16.412171236255755, 120.60080932619908),
              infoWindow: InfoWindow(
                title: 'Emilio F. Aguinaldo Museum',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Emilio F. Aguinaldo Museum',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Mines View Observation Deck'),
              position: LatLng(16.41957109790786, 120.62789092591491),
              infoWindow: InfoWindow(
                title: 'Mines View Observation Deck',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Mines View Observation Deck',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Our Lady of Lourdes Grotto'),
              position: LatLng(16.40959296656367, 120.58057046492034),
              infoWindow: InfoWindow(
                title: 'Our Lady of Lourdes Grotto',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Our Lady of Lourdes Grotto',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Tam-awan Village'),
              position: LatLng(16.42965008040838, 120.57638515719748),
              infoWindow: InfoWindow(
                title: 'Tam-awan Village',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Tam-awan Village',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('History trail'),
              position: LatLng(16.398384623789145, 120.61885077978056),
              infoWindow: InfoWindow(
                title: 'History trail',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'History trail',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Museo Kordilyera'),
              position: LatLng(16.405751328863772, 120.59769194372842),
              infoWindow: InfoWindow(
                title: 'Museo Kordilyera',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Museo Kordilyera',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Burnham Park'),
              position: LatLng(16.412378218856116, 120.59296956596052),
              infoWindow: InfoWindow(
                title: 'Burnham Park',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Burnham Park',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Lion’s Head'),
              position: LatLng(16.36751753864695, 120.60600944686503),
              infoWindow: InfoWindow(
                title: 'Lion’s Head',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Lion’s Head',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Bell Amphitheater'),
              position: LatLng(16.398790790572257, 120.6177925954449),
              infoWindow: InfoWindow(
                title: 'Bell Amphitheater',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Bell Amphitheater',
                          )),
                ),
              ),
            ),
            Marker(
              markerId: MarkerId('Baguio Museum'),
              position: LatLng(16.407039781729914, 120.59843781687438),
              infoWindow: InfoWindow(
                title: 'Baguio Museum',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PlaceInfoScreen(
                            placeName: 'Baguio Museum',
                          )),
                ),
              ),
            ),
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Camera(),
       bottomNavigationBar: BottomNavigation(homeFill: false, mapFill: true, favFill: false, menuFill: false),
    );
  }
}

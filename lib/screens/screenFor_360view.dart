import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
class ScreenFor360View extends StatelessWidget {
  String place;
   ScreenFor360View({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          child: Image.asset('assets/panorama/${place}.png'),
        ),
      ),
    );
  }
}
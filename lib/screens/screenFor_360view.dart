import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
class ScreenFor360View extends StatelessWidget {
  const ScreenFor360View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          child: Image.asset('assets/panorama/panorama.png'),
        ),
      ),
    );
  }
}
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({super.key, required this.place});
  final dynamic place;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place["name"]),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          CarouselSlider.builder(
            itemCount: 5,
            itemBuilder: (context, index, realIndex) {
              final picture = widget.place["pictures"][index];

              return Container(
                child: Center(
                  child: Image.asset(
                    picture,
                    fit: BoxFit.cover,
                    width: 1000,
                  ),
                ),
              );
            },
            options: CarouselOptions(height: 400),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text("Information goes here"),
        ],
      ),
    );
  }
}

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
        title: Text(
          widget.place["name"],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          CarouselSlider.builder(
            itemCount: 5,
            itemBuilder: (context, index, realIndex) {
              final picture = widget.place["pictures"];

              return Center(
                child: Image.asset(
                  "assets/images/${picture[index]}.jpg",
                  fit: BoxFit.cover,
                  width: 1000,
                  height: 300,
                ),
              );
            },
            options: CarouselOptions(
              height: 400,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(widget.place["description"]),
        ],
      ),
    );
  }
}

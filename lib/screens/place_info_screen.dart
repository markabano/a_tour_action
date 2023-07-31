import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({super.key, required this.placeName});
  final String placeName;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          CarouselSlider(
            items: [
              1,
              2,
              3,
              4,
              5,
            ].map((e) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("sample picture goes here ${e.toString()}"),
              );
            }).toList(),
            options: CarouselOptions(height: 300),
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

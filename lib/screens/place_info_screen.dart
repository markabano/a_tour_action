import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({super.key, required this.place});
  final dynamic place;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place["name"],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: isFavorite == true
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            color: Colors.red,
          ),
        ],
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
                  height: 200,
                ),
              );
            },
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(widget.place["description"]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

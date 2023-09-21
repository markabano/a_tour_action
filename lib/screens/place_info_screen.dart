import 'package:a_tour_action/screens/screenFor_360view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({super.key, required this.place});
  final dynamic place;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  bool isFavorite = false;
  bool expand = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     widget.place["name"],
        //     textAlign: TextAlign.left,
        //   ),
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         setState(() {
        //           isFavorite = !isFavorite;
        //         });
        //       },
        //       icon: isFavorite == true
        //           ? const Icon(Icons.favorite)
        //           : const Icon(Icons.favorite_border),
        //       color: Colors.red,
        //     ),
        //   ],
        //   // centerTitle: true,
        //   backgroundColor:  Colors.blue[100],
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue[100]),
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.blueAccent))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.place["name"],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                if (isFavorite == true) {
                                  addFavorite();
                                } else {
                                  removeFavorite();
                                }
                              },
                              icon: isFavorite == true
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  final picture = widget.place["pictures"];

                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        picture[index],
                        fit: BoxFit.cover,
                        width: 1000,
                        height: 200,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue[100]),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScreenFor360View(place: widget.place["name"]),
                            ));
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue)),
                      child: const Text('View in 360'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'OPENING & CLOSING HOURS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          child: Icon(Icons.access_time),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            '8:00AM - 10:00PM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.lightBlue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                // child: ReadMoreText(
                //   widget.place["description"],
                //   textAlign: TextAlign.justify,
                //   style: TextStyle(
                //       color: Colors.black54, wordSpacing: 2.5, height: 1.5),
                //   trimLines: 4,
                //   colorClickableText: Colors.pink,
                //   trimMode: TrimMode.Line,
                //   trimCollapsedText: 'Read more',
                //   trimExpandedText: 'Show less',

                // ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      expand = !expand;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place["description"],
                        maxLines: !expand ? 4 : null,
                        overflow: !expand
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            color: Colors.black87,
                            wordSpacing: 1.5,
                            height: 1.7),
                      ),
                      Text(
                        !expand ? 'Read more' : 'Read less',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addFavorite() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .doc(widget.place["id"].toString())
        .set({"data": widget.place, "isFavorite": true});
  }

  Future<void> checkFavorite() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .doc(widget.place["id"].toString())
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFavorite = true;
        });
      }
    });
  }

  Future<void> removeFavorite() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorites')
        .doc(widget.place["id"].toString())
        .delete();
  }
}

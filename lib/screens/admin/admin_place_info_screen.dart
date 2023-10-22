import 'package:a_tour_action/screens/user/screenFor_360view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPlaceInfoScreen extends StatefulWidget {
  const AdminPlaceInfoScreen({super.key, required this.place});
  final dynamic place;

  @override
  State<AdminPlaceInfoScreen> createState() => _AdminPlaceInfoScreenState();
}

class _AdminPlaceInfoScreenState extends State<AdminPlaceInfoScreen> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: deniedPlace,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: approvePlace,
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ],
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
                    child: CachedNetworkImage(
                      imageUrl: picture[index],
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 200,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScreenFor360View(place: widget.place, index: 0),
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
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        child: Icon(Icons.access_time),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${widget.place['openingTime']} - ${widget.place['closingTime']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                          color: Colors.black87, wordSpacing: 1.5, height: 1.7),
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
    );
  }

  Future<void> approvePlace() async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place['name'])
          .update({'status': 'approved'});
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deniedPlace() async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place['name'])
          .delete();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}

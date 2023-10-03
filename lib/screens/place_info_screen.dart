import 'dart:async';
import 'package:a_tour_action/screens/screenFor_360view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceInfoScreen extends StatefulWidget {
  const PlaceInfoScreen({super.key, required this.place});
  final dynamic place;

  @override
  State<PlaceInfoScreen> createState() => _PlaceInfoScreenState();
}

class _PlaceInfoScreenState extends State<PlaceInfoScreen> {
  bool isFavorite = false;
  bool expand = false;
  final reviewController = TextEditingController();

  int pageSize = 5;
  int currentPage = 1;
  DocumentSnapshot? lastReview; // Store the last visible review

  double rating = 0.0;

  final StreamController<List<DocumentSnapshot>> _reviewsStreamController =
      StreamController<List<DocumentSnapshot>>();
  final List<DocumentSnapshot> _allReviews = [];

  @override
  void initState() {
    super.initState();
    checkFavorite();
    loadReviews();
    // Fetch and set the user's existing review data
    hasUserReviewed().then((hasReviewed) {
      if (hasReviewed) {
        // User has already reviewed the place, set the initial values
        fetchUserReview().then((userReviewData) {
          setState(() {
            reviewController.text = userReviewData['reviewText'];
            rating = userReviewData['rating'] as double;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _reviewsStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overallRating =
        calculateOverallRating(_allReviews); // Calculate the overall rating
    return SafeArea(
      child: Scaffold(
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                        // Image.network(
                        //   picture[index],
                        //   fit: BoxFit.cover,
                        //   width: 1000,
                        //   height: 200,
                        // ),
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
                    const Text('Overall Rating',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: overallRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 40.0,
                          ignoreGestures: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {},
                        ),
                        const SizedBox(width: 10),
                        Text(
                          ' $overallRating',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScreenFor360View(place: widget.place),
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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue[100]),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ' My Review',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: reviewController,
                              decoration: const InputDecoration(
                                hintText: 'Write a review',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 40.0,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: onRatingChanged,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (reviewController.text.isNotEmpty) {
                                      addReview();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  child: reviewController.text.isNotEmpty
                                      ? const Text('Update')
                                      : const Text('Submit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<DocumentSnapshot>>(
                      stream: _reviewsStreamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No reviews yet.');
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final review = snapshot.data![index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(review['reviewerImageUrl']),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBarIndicator(
                                    itemSize: 20,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    rating: review['rating'],
                                    // itemCount: ,
                                  ),
                                  Text(review['reviewerName']),
                                ],
                              ),
                              subtitle: Text(review['reviewText']),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: currentPage > 1 ? previousPage : null,
                            icon: Icon(Icons.arrow_left),
                          ),
                          Text(
                            'Page $currentPage',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: _allReviews.length % pageSize == 0
                                ? nextPage
                                : null,
                            icon: Icon(Icons.arrow_right),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Future<void> addReview() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final placeId = widget.place["id"].toString();

    // Check if the user has already reviewed the place
    final hasReviewed = await hasUserReviewed();

    // User is submitting a new review or updating an existing one
    if (hasReviewed) {
      // User has already reviewed the place, update the existing review
      final existingReviewQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .limit(1)
          .get();

      if (existingReviewQuery.docs.isNotEmpty) {
        final existingReviewDoc = existingReviewQuery.docs.first;
        await existingReviewDoc.reference.update({
          'reviewText': reviewController.text,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      // User is submitting a new review
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final reviewData = {
        'userId': userId,
        'placeId': placeId,
        'reviewerName': userData['name'],
        'reviewerImageUrl': userData['imageUrl'],
        'reviewText': reviewController.text,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('reviews').add(reviewData);
    }

    // Clear the existing reviews and update the stream
    _allReviews.clear();
    _reviewsStreamController.add([]);

    // Load the updated reviews
    loadReviews();
  }

  Future<void> loadReviews() async {
    Query query = FirebaseFirestore.instance
        .collection('reviews')
        .where('placeId', isEqualTo: widget.place["id"].toString())
        .orderBy('timestamp', descending: true)
        .limit(pageSize);

    if (currentPage > 1) {
      // If it's not the first page, start after the last visible review
      query = query.startAfterDocument(lastReview!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        if (currentPage == 1) {
          // If it's the first page, clear existing reviews
          _allReviews.clear();
        }
        _allReviews.addAll(querySnapshot.docs);
        lastReview = querySnapshot.docs.last; // Update the last visible review
      });

      _reviewsStreamController.add(_allReviews);
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        loadReviews();
      });
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
      _allReviews.clear(); // Clear the existing reviews
      loadReviews();
    });
  }

  void onRatingChanged(double newRating) {
    print("Rate Star:" + newRating.toString());
    setState(() {
      rating = newRating;
    });
  }

  Future<bool> hasUserReviewed() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .where('placeId', isEqualTo: widget.place["id"].toString())
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<Map<String, dynamic>> fetchUserReview() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final placeId = widget.place["id"].toString();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .where('placeId', isEqualTo: placeId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userReview =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return userReview;
    } else {
      return {}; // Return an empty map if no review is found
    }
  }

  double calculateOverallRating(List<DocumentSnapshot> reviews) {
    if (reviews.isEmpty) {
      return 0.0; // Return 0 if there are no reviews
    }

    double totalRating = 0.0;

    for (final review in reviews) {
      final rating = review['rating'] as double;
      totalRating += rating;
    }

    return totalRating / reviews.length; // Calculate the average rating
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:a_tour_action/widgets/imageDisplay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ImageData {
  final String? imageUrl;
  final File? imageFile;

  ImageData({this.imageUrl, this.imageFile});
}

class UploadPlaceScreen extends StatefulWidget {
  const UploadPlaceScreen({super.key, this.editUploadedPlace});

  final dynamic editUploadedPlace;

  @override
  State<UploadPlaceScreen> createState() => _UploadPlaceScreenState();
}

class _UploadPlaceScreenState extends State<UploadPlaceScreen> {
  final ImagePicker picker = ImagePicker();
  List<File> _images = [];
  File? _image360;
  List<String> imageUrl = [];
  List<String> image360Url = [];
  List<String> imagesToDelete = [];
  List<String> image360ToDelete = [];
  List<ImageData> imagesData = [];

  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final descController = TextEditingController();
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  @override
  void initState() {
    super.initState();

    if (widget.editUploadedPlace != null) {
      final place = widget.editUploadedPlace;
      nameController.text = place['name'] ?? '';
      latController.text = place['lat']?.toString() ?? '';
      lngController.text = place['lng']?.toString() ?? '';
      descController.text = place['description'] ?? '';

      final openingTime = place['openingTime'];
      final closingTime = place['closingTime'];

      final timeFormat = DateFormat('hh:mm a'); // Format for "hh:mm AM/PM"

      _openingTime = openingTime != null
          ? TimeOfDay.fromDateTime(timeFormat.parse(openingTime))
          : TimeOfDay(
              hour: 0,
              minute: 0); // Default to midnight if null or parsing fails

      _closingTime = closingTime != null
          ? TimeOfDay.fromDateTime(timeFormat.parse(closingTime))
          : TimeOfDay(
              hour: 23,
              minute: 59); // Default to 11:59 PM if null or parsing fails

      if (place['panorama'] != null) {
        image360Url = List<String>.from(place['panorama']);
      }

      if (place['pictures'] != null) {
        imageUrl = List<String>.from(place['pictures']);
        // Populate the imagesData list with both URL and File images
        imagesData.addAll(imageUrl.map((url) => ImageData(imageUrl: url)));
        imagesData.addAll(_images.map((file) => ImageData(imageFile: file)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.editUploadedPlace == null
              ? const Text("Upload a Place")
              : const Text("Edit a Place"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (widget.editUploadedPlace == null) {
                  if (nameController.text.isEmpty ||
                      latController.text.isEmpty ||
                      lngController.text.isEmpty ||
                      descController.text.isEmpty ||
                      _images.isEmpty ||
                      _images.length < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  } else {
                    _uploadPlace(context);
                  }
                } else {
                  if (nameController.text.isEmpty ||
                      latController.text.isEmpty ||
                      lngController.text.isEmpty ||
                      descController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  } else {
                    _editPlace(context);
                  }
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Column(
                  children: [
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Place Name',
                        prefixIcon: const Icon(Icons.place),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: latController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Latitude',
                        prefixIcon: const Icon(Icons.location_searching),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: lngController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Longitude',
                        prefixIcon: const Icon(Icons.location_searching),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        prefixIcon: const Icon(Icons.description_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Opening Time',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _openingTimePicker(context);
                              },
                              child: _openingTime != null
                                  ? Text(
                                      _openingTime!.format(context).toString())
                                  : const Text('Pick Time'),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Closing Time',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _closingTimePicker(context);
                              },
                              child: _closingTime != null
                                  ? Text(
                                      _closingTime!.format(context).toString())
                                  : const Text('Pick Time'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('360 Image'),
                if (image360Url.isNotEmpty)
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  image360Url[0]), // Use the selected image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              // Remove the selected image at this index
                              setState(() {
                                image360ToDelete.add(image360Url[0]);
                                image360Url.removeAt(0);
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_image360 != null)
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                  _image360!), // Use the selected image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              // Remove the selected image at this index
                              setState(() {
                                _image360 = null;
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  IconButton(
                    onPressed: choose360Image,
                    icon: const Icon(Icons.add),
                  ),
                const Divider(
                  thickness: 3,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  'Select Images',
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: imageUrl.isNotEmpty
                        ? imagesData.length < 5
                            ? imagesData.length + 1
                            : imagesData.length
                        : _images.length < 5
                            ? _images.length + 1
                            : _images.length,
                    itemBuilder: (context, index) {
                      if (imageUrl.isNotEmpty) {
                        if (index == imagesData.length) {
                          return Center(
                            child: IconButton(
                              onPressed: chooseImage,
                              icon: Icon(Icons.add),
                            ),
                          );
                        } else {
                          return ImageDisplay(
                            imageUrl: imagesData[index].imageUrl,
                            imageFile: imagesData[index].imageFile,
                            onRemove: () {
                              // Handle image removal here
                              setState(() {
                                if (imagesData[index].imageUrl != null) {
                                  // It's a URL image
                                  imagesToDelete
                                      .add(imagesData[index].imageUrl!);
                                  imageUrl.remove(imagesData[index].imageUrl!);
                                } else {
                                  // It's a local file image
                                  _images.remove(imagesData[index].imageFile!);
                                }
                                imagesData.removeAt(index);
                              });
                            },
                          );
                        }
                      } else {
                        if (index == _images.length && _images.length < 5) {
                          return Center(
                            child: IconButton(
                              onPressed: chooseImage,
                              icon: Icon(Icons.add),
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Remove the selected image at this index
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // User canceled image selection
      return;
    }

    setState(() {
      final newImage = File(pickedFile.path);
      _images.add(newImage);
      imagesData.add(ImageData(imageFile: newImage)); // Add to imagesData
    });
  }

  Future<void> choose360Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      // User canceled image selection
      return;
    }

    setState(() {
      _image360 = File(pickedFile.path);
    });
    print(_image360);
  }

  void _openingTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _openingTime = value;
      });
    });
  }

  void _closingTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _closingTime = value;
      });
    });
  }

  Future<void> _uploadPlace(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final String placeName = nameController.text;
    final String lat = latController.text;
    final String lng = lngController.text;

    var getLastPlace = await FirebaseFirestore.instance
        .collection('places')
        .orderBy('id', descending: true) // Assuming you want to order by 'id'
        .limit(1) // Limit to 1 document (the latest)
        .get();

    var lastPlaceId = getLastPlace.docs.first.data()['id'];

    var searchKeywordsName = nameController.text;
    final List<String> searchKeywords =
        searchKeywordsName.toLowerCase().split(' ');

    // Clear the imageUrl list before starting to upload images
    imageUrl.clear();

    if (_images.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum Image is 5'),
        ),
      );
    } else {
      // Total number of images to upload
      final int totalImages = _images.length;

      // Initialize the counter for uploaded images
      int uploadedImages = 0;

      // Store the initial context in a variable
      BuildContext scaffoldContext = context; // Use a different variable name

      // Show a progress dialog
      showDialog(
        context: scaffoldContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Uploading Photos...'),
                LinearProgressIndicator(
                  value: uploadedImages / totalImages,
                ),
              ],
            ),
          );
        },
      );

      // Image360 Upload
      if (_image360 != null) {
        // Unique file name
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Upload to Firebase
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('places')
            .child(uid)
            .child('panorama')
            .child(fileName);

        try {
          // Store file in Firebase
          await ref.putFile(_image360!);

          // Get file URL
          final imageUrlForImage = await ref.getDownloadURL();

          // Add the URL
          image360Url.add(imageUrlForImage);

          // Increment the uploaded images counter
          uploadedImages++;

          // Update the progress indicator
          Navigator.of(scaffoldContext).pop(); // Close the progress dialog
          showDialog(
            context: scaffoldContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Uploading Photos...'),
                    LinearProgressIndicator(
                      value: uploadedImages / totalImages,
                    ),
                  ],
                ),
              );
            },
          );
        } catch (error) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload image'),
            ),
          );
        }
      }

      // Image Upload
      for (var image in _images) {
        // Unique file name
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Upload to Firebase
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('places')
            .child(uid)
            .child('images')
            .child(fileName);

        try {
          // Store file in Firebase
          await ref.putFile(File(image.path));

          // Get file URL
          final imageUrlForImage = await ref.getDownloadURL();

          // Add the URL to the list
          imageUrl.add(imageUrlForImage);

          // Increment the uploaded images counter
          uploadedImages++;

          // Update the progress indicator
          Navigator.of(scaffoldContext).pop(); // Close the progress dialog
          showDialog(
            context: scaffoldContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Uploading Photos...'),
                    LinearProgressIndicator(
                      value: uploadedImages / totalImages,
                    ),
                  ],
                ),
              );
            },
          );
        } catch (error) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload image'),
            ),
          );
        }
      }

      // Close the progress dialog
      Navigator.of(scaffoldContext).pop();
      Navigator.of(scaffoldContext).pop();

      // Details Upload
      await FirebaseFirestore.instance.collection('places').doc(placeName).set({
        'id': lastPlaceId + 1,
        'name': nameController.text,
        'openingTime': _openingTime!.format(context).toString(),
        'closingTime': _closingTime!.format(context).toString(),
        'lat': double.parse(lat),
        'lng': double.parse(lng),
        'description': descController.text,
        'pictures': imageUrl,
        'panorama': image360Url,
        'searchKeywords': searchKeywords,
        'uid': user!.uid,
      });
    }
  }

  Future<void> _editPlace(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final String oldPlaceName = widget.editUploadedPlace['name'];
    final String newPlaceName = nameController.text;
    final String lat = latController.text;
    final String lng = lngController.text;

    // Store the initial context in a variable
    BuildContext scaffoldContext = context; // Use a different variable name

    // Show a progress dialog
    showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Updating Place...'),
              LinearProgressIndicator(),
            ],
          ),
        );
      },
    );

    // Initialize a list to store the new image URLs
    List<String> newImageUrls = [];

    List<String> new360ImageUrls = [];

    // Image360 Upload (if a new image is selected)
    if (_image360 != null) {
      // Unique file name
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload to Firebase
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('places')
          .child(uid)
          .child('panorama')
          .child(fileName);

      try {
        // Store file in Firebase
        await ref.putFile(_image360!);

        // Get file URL
        final imageUrlForImage = await ref.getDownloadURL();

        // Add the URL
        new360ImageUrls.add(imageUrlForImage);
      } catch (error) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload 360-degree image'),
          ),
        );
        Navigator.of(scaffoldContext).pop(); // Close the progress dialog
        return;
      }
    } else {
      // No new 360-degree image selected, so use the existing URL if available
    }

    try {
      // Delete old 360 image from Firebase Storage
      for (final String image360 in image360ToDelete) {
        final Reference image360Ref =
            FirebaseStorage.instance.refFromURL(image360);
        await image360Ref.delete();
      }
    } catch (error) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete old images'),
        ),
      );
      Navigator.of(scaffoldContext).pop(); // Close the progress dialog
      return;
    }

    // Image Upload (for new images)
    for (var image in _images) {
      // Unique file name
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload to Firebase
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('places')
          .child(uid)
          .child('images')
          .child(fileName);

      try {
        // Store file in Firebase
        await ref.putFile(File(image.path));

        // Get file URL
        final imageUrlForImage = await ref.getDownloadURL();

        // Add the URL to the list
        newImageUrls.add(imageUrlForImage);
      } catch (error) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload image'),
          ),
        );
        Navigator.of(scaffoldContext).pop(); // Close the progress dialog
        return;
      }
    }

    try {
      // Delete old images from Firebase Storage
      for (final String imageToDelete in imagesToDelete) {
        final Reference imageToDeleteRef =
            FirebaseStorage.instance.refFromURL(imageToDelete);
        await imageToDeleteRef.delete();
      }
    } catch (error) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete old images'),
        ),
      );
      Navigator.of(scaffoldContext).pop(); // Close the progress dialog
      return;
    }

    // Update the place document with the new data and the new place name
    var searchKeywordsName = newPlaceName;
    final List<String> searchKeywords =
        searchKeywordsName.toLowerCase().split(' ');

    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(oldPlaceName)
          .delete();

      await FirebaseFirestore.instance
          .collection('places')
          .doc(newPlaceName)
          .set({
        'id': widget.editUploadedPlace['id'],
        'name': newPlaceName,
        'openingTime': _openingTime!.format(context).toString(),
        'closingTime': _closingTime!.format(context).toString(),
        'lat': double.parse(lat),
        'lng': double.parse(lng),
        'description': descController.text,
        'panorama': new360ImageUrls.isNotEmpty ? new360ImageUrls : image360Url,
        'pictures':
            newImageUrls.isNotEmpty ? newImageUrls + imageUrl : imageUrl,
        'searchKeywords': searchKeywords,
        'uid': user!.uid,
      });

      // Close the progress dialog
      Navigator.of(scaffoldContext).pop();
      Navigator.of(scaffoldContext).pop();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Place updated successfully'),
        ),
      );
    } catch (error) {
      // Handle errors here
      print('Error updating place: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating the place'),
        ),
      );
    }
  }
}

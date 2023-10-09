import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
                      decoration: const InputDecoration(
                        hintText: 'Place Name',
                      ),
                    ),
                    TextField(
                      controller: latController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Latitude',
                      ),
                    ),
                    TextField(
                      controller: lngController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Longitude',
                      ),
                    ),
                    TextField(
                      controller: descController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Description',
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
                        ? imageUrl.length < 5
                            ? imageUrl.length + 1
                            : imageUrl.length
                        : _images.length < 5
                            ? _images.length + 1
                            : _images.length,
                    itemBuilder: (context, index) {
                      if (imageUrl.isNotEmpty) {
                        if (index == imageUrl.length && imageUrl.length < 5) {
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
                                    image: NetworkImage(imageUrl[index]),
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
                                      imageUrl.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                ),
                              ),
                            ],
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
      _images.add(File(pickedFile.path));
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
            .child(placeName)
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
            .child(placeName)
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
          .child(oldPlaceName)
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

    // Image Upload (for new images)
    for (var image in _images) {
      // Unique file name
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload to Firebase
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('places')
          .child(oldPlaceName)
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

    // Rename the folder if the place name has changed
    if (oldPlaceName != newPlaceName) {
      await renameFolder(oldPlaceName, newPlaceName);
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
        'pictures': newImageUrls.isNotEmpty ? newImageUrls : imageUrl,
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

  Future<void> renameFolder(String oldFolderName, String newFolderName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      final Reference oldSubfolderRef =
          storage.ref().child('places').child(oldFolderName).child('images');
      final Reference newSubfolderRef =
          storage.ref().child('places').child(newFolderName).child('images');

      // List all items (files) in the old subfolder
      final ListResult oldSubfolderItems = await oldSubfolderRef.list();

      if (oldSubfolderItems.items.isNotEmpty) {
        // Create a Dio instance
        final Dio dio = Dio();

        // Flag to track if an error occurs during the loop
        bool errorOccurred = false;

        // Move each item (file) to the new subfolder while retaining its original name
        for (final item in oldSubfolderItems.items) {
          final String itemName = item.name;

          // Get the download URL of the item (file)
          final String downloadUrl = await item.getDownloadURL();

          // Download the file using Dio
          final Response<List<int>> response = await dio.get<List<int>>(
            downloadUrl,
            options: Options(responseType: ResponseType.bytes),
          );

          // Check if the download was successful
          if (response.statusCode == 200) {
            // Upload the downloaded file to the new location
            final Reference newItemRef = newSubfolderRef.child(itemName);
            try {
              await newItemRef.putData(Uint8List.fromList(response.data!));

              // Delete the item (file) from the old location
              await item.delete();
            } catch (e) {
              print('Error uploading file: $e');
              errorOccurred = true; // Set error flag
              break; // Exit the loop
            }
          }
        }
      }

      // After all files have been moved, delete the old subfolder if it's not empty
      final updatedOldSubfolderItems = await oldSubfolderRef.list();
      if (updatedOldSubfolderItems.items.isEmpty) {
        await oldSubfolderRef.delete();
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error renaming folders: $e');
    }

    try {
      final Reference oldSubfolderRef =
          storage.ref().child('places').child(oldFolderName).child('panorama');
      final Reference newSubfolderRef =
          storage.ref().child('places').child(newFolderName).child('panorama');

      // List all items (files) in the old subfolder
      final ListResult oldSubfolderItems = await oldSubfolderRef.list();

      if (oldSubfolderItems.items.isNotEmpty) {
        // Create a Dio instance
        final Dio dio = Dio();

        // Flag to track if an error occurs during the loop
        bool errorOccurred = false;

        // Move each item (file) to the new subfolder while retaining its original name
        for (final item in oldSubfolderItems.items) {
          final String itemName = item.name;

          // Get the download URL of the item (file)
          final String downloadUrl = await item.getDownloadURL();

          // Download the file using Dio
          final Response<List<int>> response = await dio.get<List<int>>(
            downloadUrl,
            options: Options(responseType: ResponseType.bytes),
          );

          // Check if the download was successful
          if (response.statusCode == 200) {
            // Upload the downloaded file to the new location
            final Reference newItemRef = newSubfolderRef.child(itemName);
            try {
              await newItemRef.putData(Uint8List.fromList(response.data!));

              // Delete the item (file) from the old location
              await item.delete();
            } catch (e) {
              print('Error uploading file: $e');
              errorOccurred = true; // Set error flag
              break; // Exit the loop
            }
          }
        }
      }

      // After all files have been moved, delete the old subfolder if it's not empty
      final updatedOldSubfolderItems = await oldSubfolderRef.list();
      if (updatedOldSubfolderItems.items.isEmpty) {
        await oldSubfolderRef.delete();
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error renaming folders: $e');
    }
  }
}

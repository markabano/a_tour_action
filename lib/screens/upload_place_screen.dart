import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPlaceScreen extends StatefulWidget {
  const UploadPlaceScreen({super.key});

  @override
  State<UploadPlaceScreen> createState() => _UploadPlaceScreenState();
}

class _UploadPlaceScreenState extends State<UploadPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Name',
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Latitude',
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Longitude',
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Description',
          ),
        ),
      ],
    )));
  }

  Future<List<XFile?>> pickMultipleImages() async {
    final List<XFile?> pickedFiles = [];
    final picker = ImagePicker();

    try {
      final pickedFileList = await picker.pickMultiImage(
        imageQuality: 70, // Adjust image quality as needed
      );
      if (pickedFileList != null) {
        pickedFiles.addAll(pickedFileList);
      }
    } catch (e) {
      print('Error picking images: $e');
    }

    return pickedFiles;
  }

  Future<List<String>> uploadImages(List<XFile?> pickedFiles) async {
    final List<String> downloadUrls = [];

    for (final pickedFile in pickedFiles) {
      if (pickedFile != null) {
        final fileName = basename(pickedFile.path);
        final Reference storageRef =
            FirebaseStorage.instance.ref().child(fileName);
        final UploadTask uploadTask = storageRef.putFile(
          File(pickedFile.path),
          SettableMetadata(
              contentType: 'image/jpeg'), // Adjust content type as needed
        );
        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          downloadUrls.add(downloadUrl);
        });
      }
    }

    return downloadUrls;
  }

  Future<void> placeUpload() async {
    final user = FirebaseAuth.instance.currentUser;
    final upload =
        await FirebaseFirestore.instance.collection('places').doc().set({
      'id': 'id',
      'name': 'name',
      'lat': 'lat',
      'lng': 'lng',
      'pictures': 'pictures',
      'description': 'description',
      'searchKeywords': 'searchKeywords',
      'userId': user!.uid,
    });
  }
}

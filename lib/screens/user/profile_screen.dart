import 'dart:io';
import 'dart:typed_data';
import 'package:a_tour_action/auth_page.dart';
import 'package:a_tour_action/screens/user/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  String imageUrl = '';
  String userImgUrl = '';
  Uint8List? _imageFile;
  XFile? _pickedImage;
  ImageSource? source;

  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Save'),
                  content: const Text('Are you sure you want to save?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        updateUserData();

                        //ignore image upload if no image is selected
                        if (_pickedImage == null) {
                          Navigator.pop(context);
                          return;
                        }
                        uploadImage(_pickedImage!);

                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    if (_imageFile != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_imageFile!),
                      )
                    else if (userImgUrl != '')
                      _isLoaded
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(userImgUrl, scale: 1.0),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(userImgUrl, scale: 1.0),
                            )
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.add_a_photo),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person_outline),
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
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
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
                enabled: false,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.password_outlined),
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
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.password_outlined),
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
          ]),
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    nameController.text = userData.data()!['name'];
    emailController.text = userData.data()!['email'];
    userImgUrl = userData.data()!['imageUrl'] ?? '';

    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
        ),
      );
      return;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': nameController.text,
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MenuScreen(
                    isLoaded: false,
                  )));
    }

    if (passwordController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password does not match'),
          ),
        );
        return;
      } else {
        user.updatePassword(passwordController.text);
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ),
        );
      }
    }
  }

  Future<void> pickImage() async {
    //camera or gallery
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                source = ImageSource.camera;
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                source = ImageSource.gallery;
              },
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    //Pick an image
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: source!);

    //Convert to bytes
    if (pickedImage != null) {
      _imageFile = await pickedImage.readAsBytes();
      setState(() {});
    }

    if (pickedImage == null) return;

    _pickedImage = pickedImage;
  }

  Future<void> uploadImage(XFile pickedImage) async {
    //Unique file name
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    //Upload to Firebase
    final Reference ref =
        FirebaseStorage.instance.ref().child('user_images').child(fileName);

    try {
      //delete previous image
      if (userImgUrl != '') {
        await FirebaseStorage.instance.refFromURL(userImgUrl).delete();
      }

      //store file in firebase
      await ref.putFile(File(pickedImage.path));

      //get file url
      imageUrl = await ref.getDownloadURL();

      //update user profile
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'imageUrl': imageUrl,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload image'),
        ),
      );
    }
  }
}

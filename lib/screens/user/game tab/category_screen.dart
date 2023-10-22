import 'package:a_tour_action/screens/user/game%20tab/game_quiz_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the Firestore package
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = []; // List to store category data
  String selectedCategory = ""; // Store the selected category

  @override
  void initState() {
    super.initState();
    fetchCategoriesFromFirestore(); // Call the function to fetch categories from Firestore
  }

  Future<void> fetchCategoriesFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      // Rest of the code for processing data
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          categories = querySnapshot.docs.map((doc) {
            return {
              'name': doc['name'],
              'imagePath': doc['imagePath'],
            };
          }).toList();
        });
      } else {
        const Text('error');
      }
    } catch (error) {
      print("Error retrieving data from Firestore: $error");
    }

    // final querySnapshot = await FirebaseFirestore.instance.collection('categories').get();

    // if (querySnapshot.docs.isNotEmpty) {
    //   setState(() {
    //     categories = querySnapshot.docs.map((doc) {
    //       return {
    //         'name': doc['name'],
    //         'imagePath': doc['imagePath'],
    //       };
    //     }).toList();
    //   });
    // }
    // else {
    //   const Text('error');
    // }
  }

  void handleCategoryTap(int index) {
    setState(() {
      selectedCategory = categories[index]
          ['name']; // Set the selected category based on the tapped image index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Category or Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                ),
                itemCount: categories.length, // Number of categories
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      handleCategoryTap(
                          index); // Set the selected category when an image is tapped
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Image.network(
                        categories[index]
                            ['imagePath'], // Use the image path from Firestore
                        width: 150, // Adjust the width and height as needed
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const GameQuizScreen(), // Pass the selected category
                    ),
                  );
                } else {
                  // Handle when no category is selected
                }
              },
              child: const Text("Start Quiz"),
            ),
            if (selectedCategory.isNotEmpty)
              Text(
                  "Selected Category: $selectedCategory"), // Display the selected category
          ],
        ),
      ),
    );
  }
}

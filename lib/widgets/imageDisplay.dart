import 'dart:io';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final Function? onRemove;

  ImageDisplay({this.imageUrl, this.imageFile, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : FileImage(imageFile!) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              // Call the onRemove callback when the remove button is pressed
              if (onRemove != null) {
                onRemove!();
              }
            },
            icon: const Icon(Icons.remove_circle),
          ),
        ),
      ],
    );
  }
}

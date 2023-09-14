import 'package:flutter/material.dart';

class Camera extends StatelessWidget {
  const Camera({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.fromARGB(255, 70, 159, 209),
      onPressed: () {},
      child: const Icon(Icons.camera_alt_outlined),
    );
  }
}

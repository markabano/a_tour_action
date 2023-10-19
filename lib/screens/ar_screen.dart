// ignore_for_file: camel_case_types

import 'package:ar_quido/ar_quido.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vector64;

class AR_core extends StatefulWidget {
  AR_core({super.key});

  @override
  State<AR_core> createState() => _AR_coreState();
}

class _AR_coreState extends State<AR_core> {
  String? _recognizedImage;
  ArCoreController? augmentedRealityCoreController;
  bool scanned = false;

  augmentedRealityViewCreated(ArCoreController coreController) {
    augmentedRealityCoreController = coreController;
    displayAr3D(augmentedRealityCoreController!);
  }

  displayAr3D(ArCoreController coreController) async {
    final ByteData arTextureBytes =
        await rootBundle.load('assets/images/earth_map.jpg');
    final materials = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: arTextureBytes.buffer.asUint8List(),
    );

    final ar3D = ArCoreSphere(materials: [materials]);

    final node = ArCoreNode(
      shape: ar3D,
      position: vector64.Vector3(0, 0, -1.5),
      // position: vector64.Vector3()
    );

    augmentedRealityCoreController!.addArCoreNode(node);
  }

   void _onImageDetected(BuildContext context, String? imageName) {
    if (imageName != null && _recognizedImage != imageName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recognized image: $imageName'),
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
    setState(() {
      _recognizedImage = imageName;
      scanned = true;
    });
  }

  void _onDetectedImageTapped(BuildContext context, String? imageName) {
    if (imageName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tapped on image: $imageName'), 
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    augmentedRealityCoreController?.dispose();
    // _AR_coreState().dispose();
    
    super.dispose();
    // scanned=false;
    // AR_core().dispose;
    
  //   augmentedRealityViewCreated;
  //   augmentedRealityCoreController;
  // // displayAr3D(coreController)
  // scanned.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(  
        body: Builder(
          builder: (context) {
            return  
            scanned==true ? 
            ArCoreView(
          onArCoreViewCreated: augmentedRealityViewCreated,
        ):
                ARQuidoView(
                  // onViewCreated: augmentedRealityViewCreated,
                  referenceImageNames: const ['applandroid','lionhead','test','360'],
                  onImageDetected: (imageName) =>
                      _onImageDetected(context, imageName),
                  onDetectedImageTapped: (imageName) =>
                      _onDetectedImageTapped(context, imageName),
                );
          },
        ),
      ),
    );
  }
}

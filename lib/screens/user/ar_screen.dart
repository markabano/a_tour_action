// ignore_for_file: camel_case_types

import 'package:ar_quido/ar_quido.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vector64;
import 'package:widgets_to_image/widgets_to_image.dart';

class AR_core extends StatefulWidget {
  AR_core({super.key});

  @override
  State<AR_core> createState() => _AR_coreState();
}

class _AR_coreState extends State<AR_core> {
  String? _recognizedImage;
  ArCoreController? augmentedRealityCoreController;
  bool scanned = false;
// WidgetsToImageController to access widget
  WidgetsToImageController controllerWidget = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;

  int imageHeight = 0;
  int imageWidth = 0;

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

    // final ar3D = ArCoreSphere(materials: [materials]);

    final bytes = await controllerWidget.capture();

    var arNotSphere3D = ArCoreImage(
      bytes: bytes,
      height: imageHeight,
      width: imageWidth,
    );

    final node = ArCoreNode(
      image: arNotSphere3D,
      // shape: arNotSphere3D,
      position: vector64.Vector3(0, 0, -1.5),
      // position: vector64.Vector3()
    );

    augmentedRealityCoreController!.addArCoreNode(node);
  }

  //ARQUIDO

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
    return Scaffold(
      body: Builder(
        builder: (context) {
          return scanned == true
              ? Stack(
                  children: [
                    WidgetsToImage(
                      controller: controllerWidget,
                      child: LayoutBuilder(builder: (context, constraints) {
                        imageHeight = constraints.maxHeight.toInt();
                        imageWidth = constraints.maxWidth.toInt();
                        return Column(
                          children: [
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Historical Site',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 67, 67, 67),
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Card(
                                    // color: Color.fromARGB(255, 255, 255, 255),
                                    child: Container(    
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    ArCoreView(
                      enableTapRecognizer: true,
                      onArCoreViewCreated: augmentedRealityViewCreated,
                    ),
                  ],
                )
              : ARQuidoView(
                  // onViewCreated: augmentedRealityViewCreated,
                  referenceImageNames: const [
                    'applandroid',
                    'lionhead',
                    'test',
                    '360'
                  ],
                  onImageDetected: (imageName) =>
                      _onImageDetected(context, imageName),
                  onDetectedImageTapped: (imageName) =>
                      _onDetectedImageTapped(context, imageName),
                );
        },
      ),
    );
  }
}

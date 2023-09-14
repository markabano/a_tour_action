import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vector64;

class ar_core extends StatelessWidget {
   ar_core({super.key});

  ArCoreController? augmentedRealityCoreController;
  augmentedRealityViewCreated(ArCoreController coreController){
    augmentedRealityCoreController = coreController;
    displayAr3D(augmentedRealityCoreController!);

  }
  displayAr3D(ArCoreController coreController) async{
    final ByteData arTextureBytes =  await rootBundle.load('assets/images/earth_map.jpg');
    final materials = ArCoreMaterial(
      color: Colors.blue,
      textureBytes: arTextureBytes.buffer.asUint8List(),
    );

    final ar3D = ArCoreSphere(
        materials: [materials]
    );

    final node = ArCoreNode(
      shape: ar3D,
      position: vector64.Vector3(0,0, -1.5),
      // position: vector64.Vector3()
      
    );

    augmentedRealityCoreController!.addArCoreNode(node);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ArCoreView(
            onArCoreViewCreated: augmentedRealityViewCreated,
          ),
      ),
    );
  }
}
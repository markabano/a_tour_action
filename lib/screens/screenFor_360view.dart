import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ScreenFor360View extends StatelessWidget {
  const ScreenFor360View({super.key, required this.place});
  final dynamic place;

  @override
  Widget build(BuildContext context) {
    print(place);

    return Scaffold(
      body: Center(
          child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(value: downloadProgress.progress),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageUrl: place['panorama'][0]['place'],
        imageBuilder: (context, imageProvider) {
          return PanoramaViewer(
            child: Image(image: imageProvider),
            sensorControl: SensorControl.orientation,
            longitude: 0,
            latitude: 0,
            hotspots: [
              Hotspot(
                latitude: double.parse(place['panorama'][0]['panoLat']),
                longitude: double.parse(place['panorama'][0]['panoLong']),
                width: 60.0,
                height: 60.0,
                  widget: GestureDetector(onTap: (){}, child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle,
                    color: const Color.fromARGB(90, 255, 255, 255),
                    ),
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Icon(Icons.pin_drop),
                    Text("Go Here!")
                  ],),))
              )
            ],
            onTap: (longitude, latitude, tilt) {
              print(
                  "${place['name']}'s info: \n longitude: ${longitude} \nlatitude: ${latitude} \n tilt: ${tilt}");
            },
          );
        },
      )

          // PanoramaViewer(
          //           child: Image.network(place['panorama'][0]),
          //           onImageLoad: () => const Center(child: CircularProgressIndicator(
          //             // value: ,
          //           )),
          //           sensorControl: SensorControl.orientation,
          //           latitude: 0,
          //           longitude: 0,
          //           onTap: (longitude, latitude, tilt) {
          //             print(
          //                 "${place}'s info: \n longitude: ${longitude} \nlatitude: ${latitude} \n tilt: ${tilt}");
          //           },
          //         ),
          ),
    );
  }
}

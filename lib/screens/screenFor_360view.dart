import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ScreenFor360View extends StatefulWidget {
  final dynamic place;
  int index;
  ScreenFor360View({super.key, required this.place, required this.index});

  @override
  State<ScreenFor360View> createState() => _ScreenFor360ViewState();
}

class _ScreenFor360ViewState extends State<ScreenFor360View> {
  @override
  // var index = 0;

  Widget build(BuildContext context) {
    // print(widget.place['panorama']);
    // print("index: " + widget.index.toString());
    // print("PanoLat: " +
    //     widget.place['panorama'][widget.index]['panoLat'].toString());
    // print("PanoLong: " +
    //     widget.place['panorama'][widget.index]['panoLong'].toString());
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          // onImageLoad: () => CircularProgressIndicator(),
          child: 
          widget.place['panorama'].length == 1 ?
          Image.network(
            widget.place['panorama'][widget.index],
         
          ):
          
          Image.network(
            widget.place['panorama'][widget.index]['place'],
            // loadingBuilder: (context, child, loadingProgress) {
            //   if(loadingProgress==null) return child;

            //   return CircularProgressIndicator(value: loadingProgress.expectedTotalBytes !=null? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,);
            // },
            //     frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            //   if (frame == null) {
            //     return CircularProgressIndicator();
            //   }
            //   return child;
            // },
          ),

          sensorControl: SensorControl.orientation,
          // latitude: widget.place['panorama'][widget.index]['panoLat'],
          // longitude: widget.place['panorama'][widget.index]['panoLong'],

          latitude: 0,
          longitude: 0,

          hotspots: [
            widget.place['panorama'].length == 1 ? Hotspot() : Hotspot(
                latitude: widget.place['panorama'][widget.index]['panoLat'],
                longitude: widget.place['panorama'][widget.index]['panoLong'],
                width: 100.0,
                height: 100.0,
                widget: GestureDetector(
                    onTap: () {
                      if (widget.index >= widget.place['panorama'].length - 1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenFor360View(
                                  place: widget.place, index: 0),
                            ));

                        // setState(() {
                        //   --widget.index;
                        //   if (widget.index < 0) widget.index = 0;
                        // });
                      } else if (widget.index <
                          widget.place['panorama'].length - 1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenFor360View(
                                  place: widget.place, index: ++widget.index),
                            ));

                        // setState(() {
                        //   ++widget.index;
                        //   if (widget.index > 0) widget.index = 0;
                        // });
                      }
                    },
                    child: Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: Container(
                        height: 500,
                        width: 500,
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(Radius.circular(200)),

                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 40,
                              )),
                              Expanded(
                                  child: Text(
                                "Go Here!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                            ],
                          ),
                        ),
                      ),
                    )))
          ],
          onTap: (longitude, latitude, tilt) {
            print(
                "${widget.place['name']}'s info: \n longitude: ${longitude} \nlatitude: ${latitude} \n tilt: ${tilt}");
          },
        ),

        // child: CachedNetworkImage(
        //   placeholder: (context, url) => CircularProgressIndicator() ,
        //   // progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        //   //   child: CircularProgressIndicator(value: downloadProgress.progress),
        //   // ),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        //   imageUrl: widget.place['panorama'][widget.index]['place'],
        //   imageBuilder: (context, imageProvider) {
        //     return
        //     PanoramaViewer(
        //       child: Image(image: imageProvider),
        //       sensorControl: SensorControl.orientation,
        //       longitude: 0,
        //       latitude: 0,
        //       hotspots: [
        //         Hotspot(
        //             // latitude: double.parse(widget.place['panorama'][index]['panoLat']),
        //             // longitude: double.parse(widget.place['panorama'][index]['panoLong']),
        //             width: 60.0,
        //             height: 60.0,
        //             widget: GestureDetector(
        //                 onTap: () {
        //                   if (widget.index >
        //                       widget.place['panorama'].length - 1) {
        //                     Navigator.pop(context);
        //                   } else if (widget.index <=
        //                       widget.place['panorama'].length - 1) {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                           builder: (context) => ScreenFor360View(
        //                               place: widget.place,
        //                               index: ++widget.index),
        //                         ));
        //                   }
        //                 },
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     color: const Color.fromARGB(90, 255, 255, 255),
        //                   ),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [Icon(Icons.pin_drop), Text("Go Here!")],
        //                   ),
        //                 )))
        //       ],
        //       onTap: (longitude, latitude, tilt) {
        //         print(
        //             "${widget.place['name']}'s info: \n longitude: ${longitude} \nlatitude: ${latitude} \n tilt: ${tilt}");
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }
}

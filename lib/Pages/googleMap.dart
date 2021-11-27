
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:texple_test/Components/labelCOmp.dart';
import 'package:texple_test/Pages/markerDetails.dart';
import 'package:texple_test/StateManagement/providerstate.dart';
import 'package:texple_test/tempdata.dart';
class Gmap extends StatefulWidget {
  const Gmap({Key? key}) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  @override
List<Uint8List> list = List.empty(growable: true);


  late BitmapDescriptor doneBM;

  // late GoogleMapController controller;

  Location location = Location();

  bool showColorPicker =false;

  late GoogleMapController controller;

  List labels = List.empty(growable: true);


  List<Widget> suggWidgets = List.empty(growable: true);
  suggetions()
  {WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    setState(() {
      suggWidgets.clear();
      markers.forEach((marker) {
        if(marker.infoWindow.snippet!.toUpperCase().contains(context.read<MarkerNotifier>().search_controller.text.toUpperCase()))
        {
          suggWidgets.add(LabelComp(title: marker.infoWindow.snippet!));

        }
      });
    });
  });




    return suggWidgets;

  }



  late geo.Position currentPosition;
  var geolocator = geo.Geolocator();

  static final CameraPosition cam_postion = CameraPosition(target: LatLng(37.2763726,-122.273763));

  void locatePosition() async
  {
    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    currentPosition = position;
     LatLng pos = LatLng(position.latitude,position.longitude);
     CameraPosition cameraPosition = new CameraPosition(target: pos,zoom: 14);
     controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  initState()
  {
    super.initState();
    redv = 100;
    greenv = 100;
    bluev = 100;

    context.read<MarkerNotifier>().locatePosition();
    context.read<MarkerNotifier>().addInitialMarkers();
  }

 late int redv,greenv,bluev;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      redv = pickerColor.red;
      greenv = pickerColor.green;
      bluev = pickerColor.blue;
    });

  }









  Widget build(BuildContext context) {
    // Provider.of<MarkerNotifier>(context).testFunc();
    // print("markers $markers");
    // context.watch<MarkerNotifier>().suggetions();
    // imageConvert();
    // markers.add(Marker(icon: doneBM,
    //   markerId: MarkerId('id1'),position: LatLng(22.6543,88.977),infoWindow: InfoWindow(title: 'Palace',snippet: 'Cool Place') ,));


    return Scaffold(body:
    Consumer<MarkerNotifier>(builder:(context,notifier,child){
      return  Stack(
        children: [
          Positioned(bottom: 10,
            child: Container(width: MediaQuery.of(context).size.width,height: 300,
              child: GoogleMap(markers: markers,
                initialCameraPosition: cam_postion,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled:  true,
                onMapCreated: (GoogleMapController controller12){
                  context.read<MarkerNotifier>().controller = controller12;
                  // Provider.of<MarkerNotifier>(context).controller = controller12;
                  context.read<MarkerNotifier>().locatePosition();
                  // Provider.of<MarkerNotifier>(context).locatePosition();
                },),
            ),
          ),


          Positioned(bottom: 10,left: 20,
            child: FloatingActionButton(child: Icon(Icons.add,color: Colors.blue,),
                backgroundColor: Colors.yellow[100],
                onPressed: (){
                  Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => const MarkerDetail(),
                    ),
                  );


                }),
          ),
          Positioned(top: 50,
            child: Container(decoration: BoxDecoration(color: Colors.yellow[200],borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Column(children: [

              TextFormField(decoration: InputDecoration(hintText: 'Search marker labels'),
                controller: context.read<MarkerNotifier>().search_controller,),

          ],),
            ),),

          Positioned(top: 100,
              child: Container(height: 400,width: MediaQuery.of(context).size.width,
                child: Column(children: [
           ...suggetions()
          ]),
              ))
        ],
      );
    })


    )


    ;
  }
}

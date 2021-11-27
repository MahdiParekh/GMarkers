import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import 'package:texple_test/tempdata.dart';
import 'package:texple_test/Components/labelCOmp.dart';

class MarkerNotifier extends ChangeNotifier
{

List<Widget> suggList = List.empty(growable: true);
List<Widget> checkedLabels = List.empty(growable: true);



  late geo.Position currentPosition;
  var geolocator = geo.Geolocator();

  TextEditingController search_controller = new TextEditingController();

   late GoogleMapController controller;

  Location location = Location();

// suggetions()
// {
//   suggWidgets.clear();
//   markers.forEach((marker) {
//     if(marker.infoWindow.snippet!.toUpperCase().contains(search_controller.text.toUpperCase()))
//       {
//         suggWidgets.add(LabelComp(title: marker.infoWindow.snippet!));
//
//       }
//   });
//   notifyListeners();
//   return suggWidgets;
//
// }


  imageConvert(int redv,int greenv,int bluev) async
  {
    BitmapDescriptor bdis;
    ByteData donebytes = await rootBundle.load('assets/images/marker.png');
    Uint8List doneU8 = donebytes.buffer.asUint8List(donebytes.offsetInBytes, donebytes.lengthInBytes);
    List<int> doneListInt = doneU8.cast<int>();

    img.Image? doneImg = img.decodePng(doneListInt);

    img.colorOffset(
      doneImg!,
      red: redv,
      green: greenv,
      blue: bluev,
    );


    doneImg = img.copyResize(doneImg, width: 100);

    final Uint8List doneIconColorful =
    Uint8List.fromList(img.encodePng(doneImg)); //doneImg.getBytes();
    bdis = BitmapDescriptor.fromBytes(doneIconColorful);
    return bdis;
  }


  String getRandomString(int len)
  {
    var random = Random.secure();
    var values = List<int>.generate(len, (index) => random.nextInt(255));
    return base64Encode(values);
  }

  addInitialMarkers() async
  {
    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    currentPosition = position;
    markers.clear();
    markers.add(Marker(markerId:MarkerId("abc"),position: LatLng((currentPosition.latitude+0.00003),(currentPosition.longitude)),infoWindow: InfoWindow(title: "Horenxo",snippet: "arizona is the best"),icon: BitmapDescriptor.defaultMarkerWithHue(10)));
    markers.add(Marker(markerId:MarkerId("def"),position: LatLng((currentPosition.latitude+0.00004),(currentPosition.longitude)),infoWindow: InfoWindow(title: "Lorenx",snippet: "scooby tank"),icon: BitmapDescriptor.defaultMarkerWithHue(50)));
    markers.add(Marker(markerId:MarkerId("ghi"),position: LatLng((currentPosition.latitude+0.00005),(currentPosition.longitude)),infoWindow: InfoWindow(title: "Tripati",snippet: "lorenzo",),icon: BitmapDescriptor.defaultMarkerWithHue(100)));
  }

  addMarker(String title,String label,int redv,int greenv,int bluev) async
  {
    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    currentPosition = position;
     BitmapDescriptor  bitmapDescriptor;
     String randomString = getRandomString(4);
    bitmapDescriptor = await imageConvert(redv, greenv, bluev);

    markers.add(Marker(markerId:MarkerId(randomString),position: LatLng(currentPosition.latitude,currentPosition.longitude),infoWindow: InfoWindow(title: title,snippet: label),icon: bitmapDescriptor));
    print("maek $markers");
    notifyListeners();
  }

  testFunc()
  {
    print("test function");
  }


  void locatePosition() async
  {

    geo.Position position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: pos,zoom: 34);
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }


}
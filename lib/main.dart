import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:texple_test/Pages/googleMap.dart';
import 'package:texple_test/StateManagement/providerstate.dart';




void main() async{
  // WidgetsFlutterBinding.ensureInitialized();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>MarkerNotifier(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) =>  Gmap(),
        },
      ),
    );
  }
}


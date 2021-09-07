import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/home.dart';
<<<<<<< HEAD
import 'package:flutter_application_1/ui/pages/mapPage.dart';

=======

import 'package:flutter_application_1/ui/pages/user.dart';
>>>>>>> 39e25975ca93fbe28c5faa3592f92bf42e64c336

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxiflow',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "manteka",
      ),
      home: MapScreen(),
    );
  }
}

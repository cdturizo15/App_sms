import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/home.dart';

import 'package:flutter_application_1/ui/pages/user.dart';

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
      home: MyHomePage(),
    );
  }
}

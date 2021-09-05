import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    final _initialCameraPosition =
        CameraPosition(target: LatLng(11.0041072, -74.8069813), zoom: 15);
    return Scaffold(
        appBar: AppBar(
          title: Text("Taxiflow"),
          leading: Icon(Icons.home),
          actions: [
            IconButton(
              icon: Icon(Icons.directions_car),
              onPressed: () {
                // push it back in
              },
            )
          ],
        ),
        body: GoogleMap(initialCameraPosition: _initialCameraPosition));
  }
}

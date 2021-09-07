import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen>{
  final _googleMapController
  GoogleMapController _googleMapController;

  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(10.9878,-74.7889),
          zoom: 11,
        )
    );
  }

}

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/ui/pages/imgtobytes.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var locationMessage = "";
  var infoPhone = "";
  var timeStamp = "";
  var stop = false;
  var latitude = "-";
  var longitude = "-";
  var timestamp;

  String host1 = "angelica.hopto.org";
  String host2 = "taxiflow.zapto.org";
  String host3 = "dierickb.hopto.org";

  bool isSwitched = false;

  final _initialCameraPosition =
      CameraPosition(target: LatLng(11.0041072, -74.8069813), zoom: 13);

  @override
  void initState() {
    super.initState();
    initPlaformState();
  }

  Future<void> initPlaformState() async {
    await Permission.locationWhenInUse.request();
    while (await Permission.locationWhenInUse.isDenied) {
      Permission.locationWhenInUse.request();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taxiflow"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/taxi.png",
          ),
        ),
        //Icon(Icons.home),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("WELCOME!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Color(0xffed5c52))),
              Image.asset(
                "assets/location.gif",
                height: 200,
              ),
              Text(locationMessage),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomSwitch(
                  value: isSwitched,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      isSwitched = value;
                      sendLocation(value);
                    });
                  },
                ),
              ),
              SizedBox(
                  width: 400,
                  height: 200,
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: _initialCameraPosition
                  )
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void sendLocation(bool value) async {
    //bool stop = true;
    var timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (isSwitched == false) {
        timer.cancel();
        setState(() {
          locationMessage = "Last position: $latitude , $longitude \n "
              "Last Timestamp: $timestamp";
        });
      } else {
        var position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = position.latitude.toStringAsFixed(7);
          longitude = position.longitude.toStringAsFixed(7);
          timestamp = position.timestamp.toLocal();
          locationMessage = "Current position: $latitude , $longitude \n "
              "Current Timestamp: $timestamp";
        });

        InternetAddress.lookup(host1).then((value) {
          value.forEach((element) async {
            var ip1 = (element.address);
            RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
                .then((RawDatagramSocket socket) {
              socket.send(
                  locationMessage.codeUnits, InternetAddress(ip1), 9000);
            });
          });
        });

        InternetAddress.lookup(host2).then((value) {
          value.forEach((element) async {
            var ip2 = (element.address);
            RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
                .then((RawDatagramSocket socket) {
              socket.send(
                  locationMessage.codeUnits, InternetAddress(ip2), 9000);
            });
          });
        });
        InternetAddress.lookup(host3).then((value) {
          value.forEach((element) async {
            var ip3 = (element.address);
            RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
                .then((RawDatagramSocket socket) {
              socket.send(
                  locationMessage.codeUnits, InternetAddress(ip3), 9000);
            });
          });
        });
      }
    });
  }
}

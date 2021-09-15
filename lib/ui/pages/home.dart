import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var locationMessage = "";
  var Message = '';
  var infoPhone = "";
  var timeStamp = "";
  var stop = false;
  var latitude;
  var longitude;
  var timestamp;

  String licensePlate = "AAA-000";
  String host1 = "angelica.hopto.org";
  String host2 = "taxiflow.zapto.org";
  String host3 = "dierickb.hopto.org";
  bool isSwitched = false;
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
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _showSecondPage(context);
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("WELCOME!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 40,
                      color: Color(0xffed5c52))),
              Image.asset(
                "assets/location.gif",
                height: 350,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(locationMessage),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
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
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      ),
    );
  }

  void sendLocation(bool value) async {
    //bool stop = true;
    var timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (isSwitched == false) {
        timer.cancel();
        setState(() {
          locationMessage = "Last position: $latitude , $longitude\n"
              "Last Timestamp: $timestamp";
        });
      } else {
        var position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = position.latitude.toStringAsFixed(7);
          longitude = position.longitude.toStringAsFixed(7);
          timestamp = position.timestamp.toLocal();
          locationMessage = "Current position: $latitude , $longitude\n"
              "Current Timestamp: $timestamp - License Plate: $licensePlate";
          Message = locationMessage;
        });

        udpSocket(host1);
        udpSocket(host2);
        udpSocket(host3);
      }
    });
  }

  void udpSocket(host) async {
    InternetAddress.lookup(host).then((value) {
      value.forEach((element) async {
        var ip = (element.address);
        RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
            .then((RawDatagramSocket socket) {
          socket.send(Message.codeUnits, InternetAddress(ip), 9000);
          print(Message);
        });
      });
    });
  }

  void _showSecondPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) {
      return UserPage();
    });
    Navigator.of(context).push(route);
  }
}

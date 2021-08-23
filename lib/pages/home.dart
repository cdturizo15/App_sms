import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var locationMessage = "";
  var infoPhone = "";
  String host1 = "angelica.hopto.org";
  String host2 = "taxiflow.zapto.org";
  final snackBar = SnackBar(content: Text('Mensaje enviado'));
  final snackBar1 = SnackBar(content: Text('Missing location'));
  final client = IO.io('http://angelica.hopto.org:8000', <String, dynamic>{
    'transports': ['websocket'],
  });

  final client2 = IO.io('http://taxiflow.zapto.org:8000', <String, dynamic>{
    'transports': ['websocket'],
  });

  @override
  void initState() {
    super.initState();
    initPlaformState();
    connectToServer();
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
        //shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.all(Radius.circular(5))),
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
      body: Center(
        //width: double.infinity,
        //margin: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text("WELCOME!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    color: Color(0xffed5c52))),
            Image.asset(
              "assets/location.gif",
              height: 250,
            ),
            RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text("FIND ME", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  getCurrentLocation();
                }),
            Text(locationMessage),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("SEND", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          sendLocation();
                          Text(infoPhone);
                        }),
                  ],
                ),
              ),
            ),
          ],
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

  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage =
      "Current position: ${position.latitude.toStringAsFixed(7)} , ${position.longitude.toStringAsFixed(7)}";
    });
  }

  void connectToServer() {
    client.connect();
    client.on('connect', (_) => print('connect: ${client.id}'));
    client.on('connect', (_) => print('connect: ${client2.id}'));
  }

  void sendLocation() {
    if (locationMessage == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }
    else {
      client.emit('msg', locationMessage);
      client2.emit('msg', locationMessage);

      InternetAddress.lookup(host1).then((value) {
        value.forEach((element) async {
          var ip1 = (element.address);
          RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
              .then((RawDatagramSocket socket) {
            socket.send(locationMessage.codeUnits, InternetAddress(ip1), 9000);
          });
        });
      });

      InternetAddress.lookup(host2).then((value) {
        value.forEach((element) async {
          var ip2 = (element.address);
          RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
              .then((RawDatagramSocket socket) {
            socket.send(locationMessage.codeUnits, InternetAddress(ip2), 9000);
          });
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

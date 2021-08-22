import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/pages/second_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var locationMessage = "";
  var numberMessage = "";
  final uclient = RawDatagramSocket.bind('181.235.94.157',9000);
  final client = IO.io('http://181.235.94.157:9000',
      <String, dynamic>{
        'transports' : ['websocket'],
      });

  @override
  void initState(){
    super.initState();
    initPlaformState();
    connectToServer();
  }
  Future <void> initPlaformState() async{
    await Permission.locationWhenInUse.request();
    while(await Permission.locationWhenInUse.isDenied) {
      Permission.locationWhenInUse.request();
    }
  }
  void connectToServer(){
      client.connect();
      client.on('connect',(_) => print('connect: ${client.id}'));


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
            icon: Icon(Icons.message),
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
            Text(numberMessage,
                style: TextStyle(fontSize: 10, color: Colors.grey)),
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
  void sendLocation() {
    client.emit('msg',locationMessage);

  }

}
  void _showSecondPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) {
      return SecondPage();
    });
    Navigator.of(context).push(route);
  }


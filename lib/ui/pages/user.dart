import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/home.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:permission_handler/permission_handler.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
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

        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _showHomePage(context);
            },
          )
        ],
        //Icon(Icons.home),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "https://www.movilidadbogota.gov.co/web/sites/default/files/Noticias/26-08-2020/jose_castaneda.jpg")))),
          Text("Juan Pablo Diaz", textScaleFactor: 2.0),
          Text("ID: 123456789", textScaleFactor: 1.5),
          Text("PLACA: WMQ-397", textScaleFactor: 1.5),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.network(
                "https://http2.mlstatic.com/D_NQ_NP_764427-MCO43645490226_102020-O.jpg"),
          ),
        ],
      )),
      backgroundColor: Colors.white,
    );
  }

  void _showHomePage(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) {
      return MyHomePage();
    });
    Navigator.of(context).push(route);
  }
}

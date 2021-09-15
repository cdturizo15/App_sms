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
  final _formKey = GlobalKey<FormState>();
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
          Text("PLACA: AAA-000", textScaleFactor: 1.5),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      var licensePlate = value;
                      print(licensePlate);
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 160.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar || call a server or save the information in a database.

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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

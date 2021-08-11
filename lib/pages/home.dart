import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_application_1/pages/second_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var locationMessage = "";
  var numberMessage = "";
  late String phoneNumber;
  final Telephony telephony = Telephony.instance;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState(){
    super.initState();
    initPlaformState();
  }
  Future <void> initPlaformState() async{
    await [Permission.sms,Permission.locationWhenInUse].request();
    while(await Permission.sms.isDenied) {
      Permission.sms.request();
    }
    while(await Permission.locationWhenInUse.isDenied) {
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
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insert phone number';
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: 'Celular',
                        labelText: 'Phone Number',
                      ),
                    ),
                    RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("SEND", style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          SendSMS();
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
      numberMessage =
      "insert the phone number you want to share your location with";
    });
  }


  void SendSMS() async {

    if (locationMessage == "") {
      final snackBar1 = SnackBar(content: Text('Missing location'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } else {
      if (_phoneController.text == ""){
        final snackBar2 = SnackBar(content: Text('Missing number'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }
      else{

        telephony.sendSms(to: _phoneController.text, message: locationMessage);
          //final snackBar = SnackBar(content: Text('Mensaje enviado'));
          //ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _showSecondPage(context);
      }
    }
  }

  void _showSecondPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) {
      return SecondPage();
    });
    Navigator.of(context).push(route);
  }
}

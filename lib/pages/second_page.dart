import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS LOCATION"),
        //shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.all(Radius.circular(5))),
        //leading: Icon(Icons.arrow_back),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("", style: TextStyle(fontSize: 30)),
            Image.asset("assets/sent.gif"),
            Text("SENT!",
                style: TextStyle(
                    fontFamily: "manteka",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 45,
                    color: Color(0xffed5c52))),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

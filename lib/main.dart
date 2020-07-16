import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/GettingStartedScreen.dart';

void main() {
  runApp(MaterialApp(
    title: "Flutter Demo",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        alignment: Alignment.center,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 230)),
            Container(
                height: 270,
                width: 270,
                child: new Image.asset("images/logo.png", width:200, height: 200,)),
            new Text("My Lawyer",style: GoogleFonts.ubuntuMono(fontSize: 30,fontWeight: FontWeight.w400),),
            new Padding(padding: EdgeInsets.only(top: 190)),
            SpinKitRipple(
              color: Colors.blue,
              size: 50.0,
            ),
//                new Padding(padding: EdgeInsets.only(top: 230)),
          ],
        ),
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GettingStartedScreen()));
    debugPrint("5 seconds Done");
  }
}

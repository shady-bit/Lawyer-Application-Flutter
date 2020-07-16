import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lawyer_application/Screens/Dashboard.dart';
import 'package:lawyer_application/Screens/LawyerForm.dart';
import 'package:lawyer_application/Screens/emailSignIn.dart';

class PhoneSignInScreen extends StatefulWidget {
  @override
  _PhoneSignInScreenState createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>(); //Scaffold key to identify this particular scaffold
  String phoneNo;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    debugPrint(" Entered Verify Function");
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      debugPrint("Verify Function done");
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential user) {
      _displaySnackBar(context);
      print('verified');
      print("pushed screen from verification Success");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verifiedFailed);
  }

  //Show dialog box to enter user OTP code
  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Enter OTP'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Center(
                child: new FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Done'),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await signIn();
                    setTypeofuser();
                  },
                  color: Colors.blue,
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    await FirebaseAuth.instance.signInWithCredential(credential);
    print("Pushed Screen from SignIn Function");
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Enter your Phone number",
          style: TextStyle(
              fontSize: 23, color: Colors.black, fontWeight: FontWeight.w300),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(23, 0, 23, 0),
                child: new TextField(
                  autofocus: true,
                  onChanged: (value) {
                    this.phoneNo = value;
                  },
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  showCursor: true,
                  maxLength: 14,
                  decoration: new InputDecoration(
                    hintText: "Phone Number",
                    fillColor: Colors.white,
                    focusColor: Colors.white70,
                    prefixIcon: Icon(
                      Icons.dialpad,
                      color: Colors.black,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(22.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: new Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: verifyPhone,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: new OutlineButton(
                        child: Padding(
                          child: new Text("I'am a Lawyer !"),
                          padding: EdgeInsets.all(12),
                        ),
                        onPressed: pushLawyerScreen,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //To display a Sign In successfull Snakbar
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Uploaded Successfully !'),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void pushLawyerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => emailSignIn()),
    );
    debugPrint("Pushed to Lawyer form Screen");
  }

  Future<void> setTypeofuser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String Userid = user.uid;
    var res = Firestore.instance
        .collection("Users")
        .document(Userid)
        .setData({"userType": "Client", "uid": Userid.toString()});
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lawyer_application/Screens/bookAppointment.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lawyer_application/Screens/paymentScreen.dart';
import 'package:lawyer_application/Screens/seeLocationScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_color/random_color.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  String docId;

  DetailScreen(this.docId);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DocumentSnapshot userDetails;
  bool isButtonDisabled = false;
  String _name, _email, _address,userType;
  int cFought, cWon, cLost, age, fees, number;
  List<String> category = new List();
  var loaded = false;

  @override
  void initState() {
    super.initState();
    getInitialData();
    getTypeOfUser();
    print("User Type is $userType");
    setButtonState();
    print("Button state changed to $isButtonDisabled");
  }

  void getInitialData() async {
    print("docid" + widget.docId);
    var res = await Firestore.instance
        .collection("Users")
        .document(widget.docId)
        .get();
    print(res.exists);
    setState(() {
      _name = res.data["name"];
      _email = res.data["emailId"];
      _address = res.data["state"];
      number = res.data["number"];
//        category  = res.data["cases_category"];
      cLost = res.data["cLost"];
      cWon = res.data["cWon"];
      age = res.data["age"];
      fees = res.data["fees"];
      cFought = res.data["cFought"];
      loaded = true;
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Lawyer Details",
            style: TextStyle(
                color: Colors.black, fontSize: 23, fontWeight: FontWeight.w300),
          ),
          centerTitle: true,
        ),
        body: !loaded
            ? Center(
                child: SpinKitRipple(
                  color: Colors.blue,
                  size: 70,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 8)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              new CircleAvatar(
                                child: Text(
                                  nameTrim(_name),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                radius: 70,
                                backgroundColor: generateColors(),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              new Text(
                                _name.toString(),
                                style: TextStyle(fontSize: 28),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Expanded(
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        child: Text(
                                          "Book",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(14),
                                      ),
                                      onPressed: isButtonDisabled ? null : bookAppoint,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  new SizedBox(
                                    width: 20,
                                  ),
                                  new Expanded(
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        child: Text(
                                          "Location",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(14),
                                      ),
                                      onPressed: _seeLocation,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Email Id : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(_email.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Age : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text("$age yrs",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Phone Number : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text("+91$number",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "State : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          _address,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Cases Fought : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(cFought.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Cases Won : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(cWon.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Cases Lost : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(cLost.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                new SizedBox(height: 20),
                                Text("Types of cases founght :",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                new SizedBox(height: 10),
                                Text("*Divorce Cases",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent)),
                                new SizedBox(height: 10),
                                Text("*Affidavit Cases",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent)),
                                new SizedBox(height: 10),
                                Text("*Criminal Cases",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent)),
                                new SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Fees charged: ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${formatCurrency.format(fees)}",
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red)),
                                  ],
                                ),
                                SizedBox(height: 26,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                child: Padding(
                                  child: Text(
                                    "Pay fees",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(14),
                                ),
                                onPressed: isButtonDisabled ? null : payFees,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40,)
                    ],
                  ),
                ),
              ));
  }

  void mailLawyer() {
    print("mail lawyer");
  }

  void bookAppoint() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => bookAppointment(widget.docId)));
  }

  getDetail() async {
    var result =
        await Firestore.instance.collection("Users").document(widget.docId);
    result.get().then((res) {
      setState(() {
        _name = res.data["name"];
        _email = res.data["emailId"];
        _address = res.data["state"];
        number = res.data["number"];
//        category  = res.data["cases_category"];
        cLost = res.data["cLost"];
        cWon = res.data["cWon"];
        age = res.data["age"];
        fees = res.data["fees"];
        cFought = res.data["cFought"];
      });
      print(_name);
    });
  }

  String nameTrim(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 1;
    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

//   _launchURL(String toMailId, String subject, String body) async {
//     var url = 'mailto:$toMailId?subject=$subject&body=$body';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _seeLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Color generateColors() {
    RandomColor _randomColor = RandomColor();
    Color _color =
        _randomColor.randomColor(colorBrightness: ColorBrightness.light);
    return _color;
  }

  void payFees() {
    print("pushed to payment Screen");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => paymentScreen()),
    );
  }
  
  Future<void> getTypeOfUser() async{
    String uid;
    FirebaseUser Currentuser = await _firebaseAuth.currentUser();
    uid = Currentuser.uid;
    print("Inside getCurrentUser Function Current user Id is $uid");
    var result = await Firestore.instance.collection("Users").document(uid);
    result.get().then((value){
      setState(() {
        this.userType = value.data["userType"];
        print("User Type : $userType");
      });
    });
  }

  void setButtonState() {
    if(userType == "Client"){
      setState(() {
        isButtonDisabled = true;
      });
    }else{
      setState(() {
        isButtonDisabled = false;
      });
    }

  }
}

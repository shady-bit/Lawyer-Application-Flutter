import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_application/Screens/DetailScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lawyer_application/Screens/notificationScreen.dart';

import 'package:lawyer_application/model/crud.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:random_color/random_color.dart';

void main() {
  runApp(MaterialApp(
    title: "Dashboard",
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser();
  int win;
  String userid;
  var loaded = false;

//  RandomColor _randomColor = RandomColor();
//  Color _color = _randomColor.randomColor();

  List usersList = [];

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() async {
    var allUsersCollection = await  Firestore.instance.collection("Users").where("userType", isEqualTo: "Lawyer").getDocuments();
    var usersList = [];
    for (var doc in allUsersCollection.documents) {
      var docData = doc.data;
      docData["uid"] = doc.documentID;
      usersList.add(docData);
    }
    print(usersList);
    setState(() {
      this.usersList = usersList;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none,size: 28,),
            onPressed: () {
              notification();
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "List of Lawyers",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
      body: 
      !loaded ?
      Center(
        child: SpinKitRipple(color: Colors.blue,size: 70, ),
      ):
      usersList.length == 0 ?
      Center(
        child: Text(
          "No Lawyers found!"
        ),
      ):
      lawyerList()
      ,
    );
  }

  Widget lawyerList() =>
    ListView.builder(
      itemCount:usersList.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Card(
            shadowColor: Colors.grey,
            elevation: 2,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.lightBlueAccent, width: 1.0),
              borderRadius: BorderRadius.circular(20),

            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        child: Text(nameTrim(
                            usersList[i]['name']),style: TextStyle(color: Colors.white),),
                        radius: 30,
                        backgroundColor:generateColors(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          usersList[i]['name'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "Win Percentage: " +
                              winRatio(usersList[i]['cWon'], usersList[i]['cFought']).toString() +"%",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: win > 60 ? Colors.green :Colors.red),
                        )
                      ],
                    ),
                    Column(
//                              crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            child: Text(
                              "View Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed: () {
                            viewProfile(usersList[i]["uid"]);
                          },
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );


  int winRatio(int cWon,int cFought) {
    print("Entered in Win function");
    int per;
    int winCount = cWon, totalCount = cFought;
    double percentage;
    print(winCount);
    print(totalCount);
    percentage = (winCount * 100) / totalCount;
    print(percentage);
    per = percentage.round();
     win = per;
  return per;
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

  void clickCard() {
    debugPrint("hi");
  }

  Future<String> viewProfile(String uid) async{
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => DetailScreen(uid)
    ));
  }

  void notification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => notificationScreen()),
    );
  }

  Color generateColors() {
        RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorBrightness: ColorBrightness.light
    );
    return _color;
  }
}

//snapshot.data.document[i].data['carName'],

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class notificationScreen extends StatefulWidget {
  @override
  _notificationScreenState createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {

  List notificationList = [];
  List notificationListClient = [];
  var userint = 1;
  String userType;
  bool switchColor = true;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _lawyerName;

  @override
  void initState() {
    getAllNotification();
    getUserInt();
    print("user int is : $userint");
    super.initState();
    print(notificationList.length);
    print(notificationListClient.length);
  }


  void getAllNotification() async {
    String uid;
    FirebaseUser user = await _firebaseAuth.currentUser();
    uid = user.uid;
    print(userType);
    var usersData = await Firestore().collection("Users").document(uid).get();
    var allUsersNotification = await Firestore.instance.collection("Notification")
      .where(
        usersData["userType"] == "Client" ?
        "clientUID"
        :
        "lawyerUID"
        , 
        isEqualTo: uid
      )
      .where(
        "userType",
        isEqualTo: usersData["userType"]
      )
      .getDocuments();
    print("Here");
    var usersList = [];
    for (var doc in allUsersNotification.documents) {
      print(doc.data);
      var docData = doc.data;
      docData["uid"] = doc.documentID;
      usersList.add(docData);
    }
    setState(() {
      this.notificationList = usersList;
      userType = usersData["userType"];
      print("Notification Length: $notificationList");
      if (userType == "Lawyer")
        _lawyerName = usersData["name"];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Notification",style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.w300),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
          )
        ],
      ),
      body:
      notificationList.length == 0 ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.notifications_off,size: 100,),
            new Text("No Notices Right Now ! ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            new FlatButton(onPressed:goback, child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),child: Text("View Dashboard",style: TextStyle(color: Colors.white),)),color: Colors.blue,shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),)
          ],
        )
      )

      :switchNow()
    );
  }



  Widget notificationCards() => ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context,i){
        return Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(side: new BorderSide(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text("Posted at",style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.start,),
                    SizedBox(height: 10,),
                    Text(notificationList[i]["name"] + " is requesting an appointment with you on " + {notificationList[i]["date"]}.toString(),style: TextStyle(color: Colors.black,fontSize: 15),),
                    Text("Email Id : " + notificationList[i]["emailId"].toString(),style: TextStyle(color: Colors.black,fontSize: 15),),
                    Text("Phone Number : " + notificationList[i]["number"].toString(),style: TextStyle(color: Colors.black,fontSize: 15),),
                    SizedBox(height: 10,),
                    Text("Context : ",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(notificationList[i]["contextCase"],
                      style: TextStyle(color: Colors.black,fontSize: 15,fontStyle: FontStyle.italic),),
                  SizedBox(height: 20,),
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
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed:(){
                            sendResult(notificationList[i], true,switchColor);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Accepted appointment respone send to the client...'),
                              duration: Duration(seconds: 3),
                            ));
                          },
                          color: switchColor?Colors.blue:Colors.grey,
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
                              "Decline",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed: () {
                            sendResult(notificationList[i], false, switchColor);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Declined appointment respone send to the client...'),
                              duration: Duration(seconds: 3),
                            ));
                          },
                          color: switchColor?Colors.blue:Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });

  Widget notificationCardsClient() => ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context,i){
        return Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(side: new BorderSide(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//                    Text("Posted at " + notificationList[i]["postedDate"].toString(),style: TextStyle(color: Colors.grey,fontSize: 12),textAlign: TextAlign.start,),
                  SizedBox(height: 10,),
//                    Text(notificationList[i]["name"] + " is requesting an appointment with you on " + notificationList[i]["date"],style: TextStyle(color: Colors.black,fontSize: 15),),
                  Icon(Icons.info_outline,color: Colors.amber,size: 25,),
                  Text("Hi,",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                  Text("This is to inform you that the lawyer named ${notificationList[i]["lawyerName"]} has ${notificationList[i]["lawyerresponse"]} your appointment request.",style: TextStyle(color: Colors.black,fontSize: 15),),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      });

  void inputData() async {

  }

  void goback() {
    Navigator.pop(context);
  }


  //refreshing notification screen
  void refresh() {
      setState(() {
        getAllNotification();
      });
  }


  //function for lawyer accepts client request
  void sendResult(var notificationData, bool result, bool switchColor) async{
    print("Accept request");
    var res = await Firestore.instance.collection("Notification").document().setData({
      "lawyerName": _lawyerName,
      "lawyerresponse": result ? "Accepted" : "Rejected",
      "lawyerUID": notificationData["lawyerUID"],
      "clientUID": notificationData["clientUID"],
      "userType": "Client"
    });
    setState(() {
      switchColor = false;
    });

  }

  //inside body switching between ListViews
  Widget switchNow() {
    return userType == "Client" ?
    notificationCardsClient() : notificationCards();
  }

void getUserInt() {
    if(userType == "Client"){
      setState(() {
        userint = 0;
      });
    }else{
      setState(() {
        userint = 1;
      });
    }
}

}

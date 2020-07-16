import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';


class bookAppointment extends StatefulWidget {
  String docId;
  bookAppointment(this.docId);
  @override
  _bookAppointmentState createState() => _bookAppointmentState();
}

class _bookAppointmentState extends State<bookAppointment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   String _name,_email,_contextCase;
  final focus = FocusNode();
   int _number;
  DateTime selectedDate = DateTime.now();
  DateTime timeStamp = DateTime.now();


  Future<bool> _showDialog(BuildContext context,String error) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Icon(Icons.warning,color: Colors.redAccent,size: 40,),
            content:Text(error,style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Center(
                child: new FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Ok'),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.blue,
                ),
              ),
            ],
          );
        });
  }
  Future<bool> _appointmentDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Icon(Icons.done_outline,color: Colors.green,size: 40,),
            content:Text("Appointment request has been sent to the Lawyer wait for his/her response.",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Center(
                child: new FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Ok'),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    _formKey.currentState.reset();
                    Navigator.pop(context);
                  },
                  color: Colors.blue,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Book Appointment",style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.w300),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              new Form(
                key: _formKey,
                  child: Column(
                children: <Widget>[
                  new Text(
                    "*All the fields are mandatory !",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter your name';
                      }
                    },
                    onSaved: (input) {
                      _name = input;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: "Your Name",
                      labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.perm_identity,
//                      color: Colors.redAccent,
//                    ),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter your email address';
                      }
                    },
                    onSaved: (input) {
                      _email = input;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: "Your Email ID",
                      labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.perm_identity,
//                      color: Colors.redAccent,
//                    ),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter your Phone number';
                      }
                    },
                    onSaved: (input) {
                      _number = int.parse(input);
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.perm_identity,
//                      color: Colors.redAccent,
//                    ),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    autofocus: false,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please Specify the type of case of yours';
                      }
                    },
                    onSaved: (input) {
                      _contextCase = input;
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: "Context of Case",
                      labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.perm_identity,
//                      color: Colors.redAccent,
//                    ),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 15,),
                  new Text("Select appointment date",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.blue,
                        icon: Icon(Icons.calendar_today),
                        label: Text(" Select Date"),
                        onPressed: ()=> _selectDate(context),
//                      child: Text("Select Date",style: TextStyle(color: Colors.white,fontSize: 14)),
                      ),
                      Text(formatter.format(selectedDate),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500)),

                    ],
                  ),
                  new SizedBox(height: 40,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            child: Text(
                              "Request Appointment",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed: requestAppointment,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
  }



  Future<void> requestAppointment() async{
    final formState = _formKey.currentState;
    if (formState.validate()){
      formState.save();
      try{
        var dataObject = {
          "name": _name,
          "emailId": _email,
          "number":_number,
          "contextCase":_contextCase,
          "date":selectedDate.toLocal(),
          "postedDate": timeStamp.toLocal(),
          "userType":"Lawyer",
          "lawyerUID":widget.docId.toString(),
          "clientUID": (await FirebaseAuth.instance.currentUser()).uid
        };
        await Firestore()
            .collection("Notification")
            .document().setData(dataObject);

        _appointmentDialog(context);
//        Navigator.pop(context);
      }catch(e){
        _showDialog(context,e.toString());
      }

    }else{
      print("validator Error");
    }
    print("request Appointment");
  }
}
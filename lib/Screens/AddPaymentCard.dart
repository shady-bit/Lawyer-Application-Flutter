import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPaymentCard extends StatefulWidget {
  @override
  _AddPaymentCardState createState() => _AddPaymentCardState();
}

class _AddPaymentCardState extends State<AddPaymentCard> {
 final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
 FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 String _cardholder,_cardExpiry,_cardBankName;
 int _cardNumber,_cardCvv;
 static const menuItems = <String>[
   "Visa",
   "masterCard",
   "rupay",
   "maestro",
 ];
// final List<DropdownMenuItem<String>> _dropmenuItems = menuItems.map(String value)
// String _cardNumber;


  Future<bool> _appointmentDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Icon(Icons.done_outline,color: Colors.green,size: 50,),
            content:Text("Card Successfully Added !",style: TextStyle(fontSize: 18,),textAlign: TextAlign.center,),
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
                    _formkey.currentState.reset();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add Card",
          style: TextStyle(
              color: Colors.black, fontSize: 23, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
          child: Container(
//          color: Colors.grey,
            child: Column(
              children: <Widget>[
                new Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      new TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Bank Name';
                          }
                        },
                        autofocus: true,
                        onChanged: (value) {
                          this._cardBankName = value;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          hintText: "Bank Name",
                          fillColor: Colors.white,
                          focusColor: Colors.white70,
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.black,
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      new TextFormField(
                        maxLength: 16,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Card Number';
                          }
                        },
                        autofocus: true,
                        onChanged: (value) {
                          this._cardNumber = int.parse(value);
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          hintText: "Card Number",
                          fillColor: Colors.white,
                          focusColor: Colors.white70,
                          prefixIcon: Icon(
                            Icons.credit_card,
                            color: Colors.black,
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      new TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Card Expiry';
                          }
                        },
                        autofocus: true,
                        onChanged: (value) {
                          this._cardExpiry = value;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          hintText: "Card Expiry  e.g 10/25",
                          fillColor: Colors.white,
                          focusColor: Colors.white70,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      new TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Card Holder Name';
                          }
                        },
                        autofocus: true,
                        onChanged: (value) {
                          this._cardholder = value;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          hintText: "Card Holder Name",
                          fillColor: Colors.white,
                          focusColor: Colors.white70,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      new TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter Cvv';
                          }
                        },
                        autofocus: true,
                        onChanged: (value) {
                          this._cardCvv = int.parse(value);
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          hintText: "Cvv",
                          fillColor: Colors.white,
                          focusColor: Colors.white70,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                new SizedBox(height: 20,),
                new Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                        child: Padding(
                          child: Text(
                            "Add Card",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          padding: EdgeInsets.all(14),
                        ),
                        onPressed: addCard,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addCard() async{
    print("Add Card");
    final formState = _formkey.currentState;
    if(formState.validate()){
      formState.save();
      String uid;
      FirebaseUser user = await _firebaseAuth.currentUser();
      uid = user.uid;
      var result = await Firestore.instance.collection("Users").document(uid).collection("Cards").document().setData({
        "bankname":_cardBankName,
        "cardHolder":_cardholder,
        "cardNumber":_cardNumber,
        "cardExpiry":_cardExpiry,
        "cvv":_cardCvv,
//      "cardType":_cardType,
      });
      _appointmentDialog(context);
    }
  }
}

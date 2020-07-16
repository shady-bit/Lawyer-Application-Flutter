import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_application/Screens/Dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lawyer_application/Screens/LawyerForm.dart';

class emailSignIn extends StatefulWidget {
  @override
  _emailSignInState createState() => _emailSignInState();
}

class _emailSignInState extends State<emailSignIn> {
  bool loaded = true;
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Email Login",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            fontSize: 23
              ),
        ),
      ),
      backgroundColor: Colors.white,
      body:
      !loaded ?
      Center(
        child: CircularProgressIndicator(),
      ):Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            new Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    new TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Provide your Email';
                        }
                      },
                      autofocus: true,
                      onChanged: (value) {
                        this._email = value;
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.grey,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                        hintText: "Email ID",
                        fillColor: Colors.white,
                        focusColor: Colors.white70,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20)),
                    new TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Provide password';
                        } else if (input.length < 6) {
                          return 'Password should be of atleast 6 characters';
                        }
                      },
                      autofocus: false,
                      obscureText: true,
                      onChanged: (value) {
                        this._password = value;
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.grey,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Password",
                        focusColor: Colors.white70,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 28,),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: signIn,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            new Padding(padding: EdgeInsets.only(top: 10)),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new OutlineButton(
                      child: Padding(
                        child: new Text(
                          "Create Account",
                          style: TextStyle(fontSize: 14),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: pushToCreateAccount,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
              ],
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        debugPrint("Entered In TRY block");
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        debugPrint("Authentication Done");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardScreen()));

      } catch (e) {
        print(e);
        _showDialog(context,e.toString());
      }
    }
  }

  void pushToCreateAccount() {
    print("pushed to create Account screen");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LawyerForm()),
    );
  }
}

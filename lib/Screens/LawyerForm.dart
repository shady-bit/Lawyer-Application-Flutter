import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_application/Screens/Dashboard.dart';

class LawyerForm extends StatefulWidget {
  @override
  _LawyerFormState createState() => _LawyerFormState();
}

bool statusLoggedIn = false;

class _LawyerFormState extends State<LawyerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name,
      _email,
      _state,
      _password;

  int  _age,
      _casesFought,
      _casesLost,
      _casesWon,
      _number,
      _fees;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//  int _casesFought;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool categor_Civil = false;
  bool categor_Criminal = false;
  bool categor_Divorce = false;
  bool categor_Affidavit = false;

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Icon(Icons.error,color: Colors.yellow,size: 40,),
            content:Text("Verification mail has been sent to your given Email ID.Click the link in the mail to verify.",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Create a Lawyer Account !",
          style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w300,
              ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              new Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "*All the fields are mandatory !",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter your name';
                        }
                      },
                      onSaved: (input) {
                        _name = input;
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Full Name",
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
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter your Email Id';
                        }
                      },
                      onSaved: (input) {
                        _email = input;
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Email ID",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.email,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter password';
                        } else if (input.length < 6) {
                          return 'Password should be  of atleast 6 characters';
                        }
                      },
                      onSaved: (input) {
                        _password = input;
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.email,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      autofocus: false,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter phone number';
                        } else if (input.length < 10) {
                          return 'Enter your phone number without country code';
                        }
                      },
                      onSaved: (input) {
                        _number = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      autofocus: false,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter your current state';
                        }
                      },
                      onSaved: (input) {
                        _state = input;
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.blue,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "State",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.place,
//                      color: Colors.blue,
//                    ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter your age';
                        }
                      },
                      onSaved: (input) {
                        _age = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Age",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter number of cases you fought';
                        }
                      },
                      onSaved: (input) {
                        _casesFought = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Cases you have founght",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter number of cases you win';
                        }
                      },
                      onSaved: (input) {
                        _casesWon = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Cases you Win",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter number of cases you lost';
                        }
                      },
                      onSaved: (input) {
                        _casesLost = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Cases you lost",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Enter your fees in Rupees';
                        }
                      },
                      onSaved: (input) {
                        _fees = int.parse(input);
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Fees Charge (Rupees)",
                        labelStyle: TextStyle(color: Colors.black),
//                    prefixIcon: Icon(
//                      Icons.person,
//                      color: Colors.redAccent,
//                    ),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 30)),
                    new Text(
                      "*Types of cases you have fought",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: categor_Civil,
                          onChanged: (bool value) {
                            setState(() {
                              categor_Civil = value;
                            });
                          },
                        ),
                        Text("Civil Cases")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: categor_Criminal,
                          onChanged: (bool value) {
                            setState(() {
                              categor_Criminal = value;
                            });
                          },
                        ),
                        Text("Criminal Cases")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: categor_Divorce,
                          onChanged: (bool value) {
                            setState(() {
                              categor_Divorce = value;
                            });
                          },
                        ),
                        Text("Divorce Cases")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: categor_Affidavit,
                          onChanged: (bool value) {
                            setState(() {
                              categor_Affidavit = value;
                            });
                          },
                        ),
                        Text("Affidavit Cases")
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(14),
                      ),
                      onPressed: signUp,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              new Padding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        ),
      ),
    );
  }

  void _UploadData() {
    debugPrint("Upload data");
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        debugPrint("Entered In TRY block");
        AuthResult authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
//        setState(() {
//          statusLoggedIn = authResult.user.isEmailVerified;
//          print(statusLoggedIn);
//        });
        if (authResult != null) {
          // authResult.user.sendEmailVerification();
          smsCodeDialog(context);
          if(true){
            try {
              // UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
              // userUpdateInfo.displayName = _name;
              var dataObject = {
                "name": _name,
                "emailId": _email,
                "state": _state,
                "age": _age,
                "cFought": _casesFought,
                "cWon": _casesWon,
                "cLost": _casesLost,
                "number":_number,
                "fees":_fees,
                "cases_category":[
                  "Divorce Cases",
                  "Criminal Cases",
                  "Affidavit Cases",
                  "Civil Cases"
                ],
                "userType":"Lawyer",
                "uid" :authResult.user.uid.toString()
              };
              await Firestore()
                  .collection("Users")
                  .document(authResult.user.uid)
                  .setData(dataObject);
              debugPrint("Account created Done");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            } catch (e) {
              print(e);
              _showDialog(context,e.toString());
              print("An error occured while trying send email");
            }
          }else{
            print("Email not Verified");
          }

        } else {
          deleteUser();
          print("Email Verification Failed");
        }
      } catch (e) {
        print(e);
        _showDialog(context,e.toString());
      }
    } else {
      print("Form Validation Error");
    }
  }

  List<String> categorydefiner() {
    print(categor_Civil);
    print(categor_Affidavit);
    print(categor_Criminal);
    print(categor_Divorce);
    int i;
    List<String> finCategory;
    List<String> stringcategory = [
      "Divorce Cases",
      "Criminal Cases",
      "Affidavit Cases",
      "Civil Cases"
    ];
    List<bool> definedCategory = [
      categor_Divorce,
      categor_Criminal,
      categor_Affidavit,
      categor_Civil
    ];
    print(definedCategory);
    for (i = 0; i <= 3; i++) {
      if (definedCategory[i] == false) {
        stringcategory.removeAt(i);
      } else {
        print(stringcategory);
      }
    }
    print(stringcategory);
    return stringcategory;
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Created Account Successfully !'),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  void deleteUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await FirebaseAuth.instance.signOut();
    user.delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lawyer_application/Screens/AddPaymentCard.dart';

class paymentScreen extends StatefulWidget {
  @override
  _paymentScreenState createState() => _paymentScreenState();
}

class _paymentScreenState extends State<paymentScreen> {
  int CardArrayLength;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List userCards;
  bool loaded = false;
  List<bool> rotate = new List();

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() async {
    FirebaseUser CurrentUser = await _firebaseAuth.currentUser();
    String uid = CurrentUser.uid;
    var allUsersCards = await Firestore.instance.collection("Users").document(uid).collection("Cards").getDocuments();
    var usersList = [];
    for (var doc in allUsersCards.documents) {
      var docData = doc.data;
      docData["uid"] = doc.documentID;
      usersList.add(docData);
    }
    print(usersList);
    setState(() {
      this.userCards = usersList;
      loaded = true;
      CardArrayLength = usersList.length;
    });
    arrayinitialise();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add Card",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPaymentCard()),
          );
        },
      ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text("Payment Methods",style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.w300),),
          centerTitle: true,
        ),
        body: !loaded ?
      Center(
      child: SpinKitCircle(color: Colors.blue,size: 60, ),
    ): userCards.length == 0 ?
    Center(
    child: Column(
      children: <Widget>[
        Icon(
          Icons.credit_card,
          size: 100,
        ),
        Text("No card added yet !",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
      ],
    )
    ):

        CardList()

    );
  }

 Widget CardList() =>
     ListView.builder(
         itemCount: userCards.length,
         itemBuilder: (context,i){
            return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    new GestureDetector(
                      onDoubleTap: (){
                        flipCard(i);
                      },
                      child:CreditCard(
                        cardNumber: "6450 8879 3864 0554",
                        cardExpiry: "30/25",
                        cardHolderName: "Card Holder",
                        cvv: "256",
                        bankName: "Kotak Mahindra Bank",
                        cardType: CardType.rupay,// Optional if you want to override Card Type
                        showBackSide: rotate[i],
                        frontBackground: CardBackgrounds.black,
                        backBackground: CardBackgrounds.white,
                        showShadow: true,
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
            );
     });

  void arrayinitialise() {
    for(var i=0; i<=CardArrayLength;i++){
      rotate.add(false);
    }
  }

  void flipCard(int i){
    setState(() {
      rotate[i] = !rotate[i];
    });

  }
}































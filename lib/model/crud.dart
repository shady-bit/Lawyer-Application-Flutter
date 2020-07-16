import 'package:cloud_firestore/cloud_firestore.dart';

class crudMethods{

  getData() async {
    return Firestore.instance.collection("users").snapshots();
  }

}


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});
//Collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

//Update the user data in DB
  Future savingUserData(String fullName, String email) async {
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "uid": uid,
      "groups": [],
      "dp": ""
    });
  }

  Future getingUserData(String uid) async {
    try {
      QuerySnapshot data = await userCollection
          .where(
            'uid',
            isEqualTo: uid,
          )
          .get();
      return data;
    } on FirebaseFirestore catch (e) {}
  }
}

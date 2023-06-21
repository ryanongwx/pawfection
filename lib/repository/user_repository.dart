import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  void addUserRepo(Map<String, dynamic> userJson, String referenceId) {
    userCollection.doc(referenceId).set(userJson);
  }

  void updateUserRepo(Map<String, dynamic> userJson, String referenceId) async {
    await userCollection
        .doc(referenceId)
        .update(userJson);
  }

  void deleteUserRepo(String referenceId) async {
    await userCollection.doc(referenceId).delete();
  }

  Future<QuerySnapshot> fetchAllUsers() async {
    return await userCollection.get();
  }
}

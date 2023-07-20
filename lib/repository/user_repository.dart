import 'dart:ffi';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UserRepository {
  late CollectionReference userCollection;

  UserRepository(bool real) {
    if (real) {
      userCollection = FirebaseFirestore.instance.collection('users');
    } else {
      userCollection = FakeFirebaseFirestore().collection('users');
    }
  }

  Future<String> addUserRepo(Map<String, dynamic> userJson) async {
    var newDocRef = userCollection.doc();
    userJson['referenceId'] = newDocRef.id;
    await newDocRef.set(userJson);
    return newDocRef.id;
  }

  void addFakeUserRepo(Map<String, dynamic> userJson) async {
    userCollection.add(userJson);
  }

  void addUserRepoWithRepoId(Map<String, dynamic> userJson) async {
    userCollection.doc(userJson['referenceId']).set(userJson);
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  void updateUserRepo(Map<String, dynamic> userJson, String referenceId) async {
    await userCollection.doc(referenceId).update(userJson);
  }

  void updateUserRepoReferenceId(Map<String, dynamic> userJson,
      String referenceId, String newReferenceId) async {
    userJson['referenceId'] = newReferenceId;
    await userCollection.doc(referenceId).update(userJson);
  }

  void deleteUserRepo(String referenceId) async {
    await userCollection.doc(referenceId).delete();
  }

  Future<QuerySnapshot> fetchAllUsers() async {
    return await userCollection.get();
  }
}

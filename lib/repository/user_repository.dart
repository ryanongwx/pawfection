import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfection/service/user_service.dart';
import 'dart:async';

import '../models/user.dart';

class UserRepository {
  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection('users');
  final userService = UserService();
  // Retrieve User Data

  Stream<QuerySnapshot> get users {
    return usercollection.snapshots();
  }

  Future<User?> findUserByUUID(String referenceId) async {
    final querySnapshot = await usercollection.get();
    final userList = userService.snapshotToUserList_modified(querySnapshot);

    for (User user in userList) {
      if (user.referenceId == referenceId) {
        return user;
      }
    }

    return null;
  }

  Future<User?> findUserByUsername(String username) async {
    final querySnapshot = await usercollection.get();
    final userList = userService.snapshotToUserList_modified(querySnapshot);

    for (User user in userList) {
      if (user.username == username) {
        return user;
      }
    }

    return null;
  }

  // Future<List<User>> getUserList() async {
  //   QuerySnapshot snapshot = await usercollection.get();
  //   return snapshot.docs
  //       .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  void addUser(User user) {
    usercollection.doc(user.referenceId).set(userService.userToJson(user));
  }

  void updateUser(User user) async {
    await usercollection
        .doc(user.referenceId)
        .update(userService.userToJson(user));
  }

  void deleteUser(User user) async {
    await usercollection.doc(user.referenceId).delete();
  }

  Future<List<User>> getUserList() async {
    QuerySnapshot snapshot = await usercollection.get();
    return snapshot.docs
        .map((doc) => userService.userFromJson(doc.data() as Map<String, dynamic>))
        .toList()
        .cast();
  }

  // Returns User object
  Future<User?> currentUser(_auth) async {
    var user = _auth.currentUser;
    if (user != null) {
      return await UserRepository().findUserByUUID(user.uid);
    } else {
      return null;
    }
  }
}

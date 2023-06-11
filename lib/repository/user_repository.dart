import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/user.dart';

class UserRepository {
  final CollectionReference usercollection =
  FirebaseFirestore.instance.collection('users');
  // Retrieve User Data

  Stream<QuerySnapshot> get users {
    return usercollection.snapshots();
  }

  List<User> snapshotToUserList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return User.fromJson(data);
      }).toList();
    }
  }

  List<User> snapshotToUserList_modified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
        as Map<String, dynamic>; // Cast to the correct data type
        return User.fromJson(data);
      }).toList();
    }
  }

  Future<User?> findUserByUUID(String referenceId) async {
    final querySnapshot = await usercollection.get();
    final userList = snapshotToUserList_modified(querySnapshot);

    for (User user in userList) {
      if (user.referenceId == referenceId) {
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
    usercollection.doc(user.referenceId).set(user.toJson());
  }

  void updateUser(User user) async {
    await usercollection.doc(user.referenceId).update(user.toJson());
  }

  void deleteUser(User user) async {
    await usercollection.doc(user.referenceId).delete();
  }
}
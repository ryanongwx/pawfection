import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorage;
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/pet.dart';
import '../models/task.dart';
import '../models/user.dart';

class DataRepository {
  final CollectionReference petcollection =
      FirebaseFirestore.instance.collection('pets');
  final CollectionReference taskcollection =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseStorage.FirebaseStorage _storage =
      FirebaseStorage.FirebaseStorage.instance;

  // Retrieve Pet Data

  Stream<QuerySnapshot> get pets {
    return petcollection.snapshots();
  }

  List<Pet> snapshotToPetList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        // return Pet(data['name'],
        //     profilepicture: ' ', description: data['description']);
        return Pet.fromJson(data);
      }).toList();
    }
  }

  // Future<List<Pet>> getPetList() async {
  //   QuerySnapshot snapshot = await petcollection.get();
  //   return snapshot.docs
  //       .map((doc) => Pet.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  Future<DocumentReference> addPet(Pet pet) {
    return petcollection.add(pet.toJson());
  }

  void updatePet(Pet pet) async {
    await petcollection.doc(pet.referenceId).update(pet.toJson());
  }

  void deletePet(Pet pet) async {
    await petcollection.doc(pet.referenceId).delete();
  }

  List<Pet> snapshotToPetList_modified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
            as Map<String, dynamic>; // Cast to the correct data type
        return Pet.fromJson(data);
      }).toList();
    }
  }

  Future<Pet?> findUserByPetID(String referenceId) async {
    final querySnapshot = await petcollection.get();
    final petList = snapshotToPetList_modified(querySnapshot);

    for (Pet pet in petList) {
      if (pet.referenceId == referenceId) {
        return pet;
      }
    }

    return null;
  }

  // Retrieve Task Data

  Stream<QuerySnapshot> get tasks {
    return taskcollection.snapshots();
  }

  List<Task> snapshotToTaskList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        // return Task(
        //   data['name'],
        //   createdby: data['createdby'],
        //   assignedto: data['assignedto'],
        //   status: data['status'],
        //   description: data['description'],
        //   resources: data['resources'],
        //   contactperson: data['contactperson'],
        //   contactpersonnumber: data['contactpersonnumber'],
        //   deadline: data['deadline'],
        // );
        return Task.fromJson(data);
      }).toList();
    }
  }

  // Future<List<Task>> getTaskList() async {
  //   QuerySnapshot snapshot = await taskcollection.get();
  //   return snapshot.docs
  //       .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  Future<DocumentReference> addTask(Task task) {
    return taskcollection.add(task.toJson());
  }

  void updateTask(Task task) async {
    await taskcollection.doc(task.referenceId).update(task.toJson());
  }

  void deleteTask(Task task) async {
    await taskcollection.doc(task.referenceId).delete();
  }

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
        // return User(
        //   data['email'],
        //   username: data['username'],
        //   role: data['role'],
        //   availabledates: data['availabledates'],
        //   preferences: data['preferences'],
        //   experiences: data['experiences'],
        //   profilepicture: data['profilepicture'],
        //   contactnumber: data['contactnumber'],
        // );
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

  Future<String> uploadImageToStorage(File file, String user_id) async {
    FirebaseStorage.Reference ref =
        _storage.ref().child('profilepictures').child(user_id);
    FirebaseStorage.UploadTask uploadTask = ref.putFile(file);
    FirebaseStorage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}

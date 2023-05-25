import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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



  // Retrieve Pet Data

  Stream<QuerySnapshot> get pets {
    return petcollection.snapshots();
  }

  List<Pet> snapshotToPetList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      throw Exception("Data is empty");
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

  // Retrieve Task Data

  Stream<QuerySnapshot> get tasks {
    return taskcollection.snapshots();
  }

  List<Task> snapshotToTaskList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      throw Exception("Data is empty");
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
      throw Exception("Data is empty");
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

  // Future<List<User>> getUserList() async {
  //   QuerySnapshot snapshot = await usercollection.get();
  //   return snapshot.docs
  //       .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  Future<DocumentReference> addUser(User user) {
    return usercollection.add(user.toJson());
  }

  void updateUser(User user) async {
    await usercollection.doc(user.referenceId).update(user.toJson());
  }

  void deleteUser(User user) async {
    await usercollection.doc(user.referenceId).delete();
  }
}

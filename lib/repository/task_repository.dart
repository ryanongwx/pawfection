import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/task.dart';

class TaskRepository {
  final CollectionReference taskcollection =
  FirebaseFirestore.instance.collection('tasks');

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
}
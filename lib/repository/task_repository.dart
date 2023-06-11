import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/service/task_service.dart';
import 'dart:async';

import '../models/task.dart';

class TaskRepository {
  final CollectionReference taskcollection =
      FirebaseFirestore.instance.collection('tasks');
  final taskService = TaskService();

  // Retrieve Task Data

  Stream<QuerySnapshot> get tasks {
    return taskcollection.snapshots();
  }

  // Future<List<Task>> getTaskList() async {
  //   QuerySnapshot snapshot = await taskcollection.get();
  //   return snapshot.docs
  //       .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  Future<DocumentReference> addTask(Task task) {
    return taskcollection.add(taskService.taskToJson(task));
  }

  void updateTask(Task task) async {
    await taskcollection
        .doc(task.referenceId)
        .update(taskService.taskToJson(task));
  }

  void deleteTask(Task task) async {
    await taskcollection.doc(task.referenceId).delete();
  }
}

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

  Future<void> addTask(Task task) {
    var newDocRef = taskcollection.doc();
    task.referenceId = newDocRef.id;
    return newDocRef.set(taskService.taskToJson(task));
  }

  void updateTask(Task task) async {
    await taskcollection
        .doc(task.referenceId)
        .update(taskService.taskToJson(task));
  }

  void deleteTask(Task task) async {
    await taskcollection.doc(task.referenceId).delete();
  }

  Future<Task?> findTaskByTaskID(String referenceId) async {
    final querySnapshot = await taskcollection.get();
    final taskList = taskService.snapshotToTaskList_modified(querySnapshot);

    for (Task task in taskList) {
      if (task.referenceId == referenceId) {
        return task;
      }
    }

    return null;
  }
}

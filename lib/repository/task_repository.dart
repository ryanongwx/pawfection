import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TaskRepository {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot> get tasks {
    return taskCollection.snapshots();
  }

  void updateTaskRepo(
      Map<String, dynamic> taskJson, String? referenceId) async {
    await taskCollection.doc(referenceId).update(taskJson);
  }

  void deleteTaskRepo(String? referenceId) async {
    await taskCollection.doc(referenceId).delete();
  }

  Future<void> addTaskRepo(Map<String, dynamic> taskJson) async {
    var newDocRef = taskCollection.doc();
    taskJson['referenceId'] = newDocRef.id;
    await newDocRef.set(taskJson);
  }

  Future<QuerySnapshot> fetchAllTasks() async {
    return await taskCollection.get();
  }
}

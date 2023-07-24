import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TaskRepository {
  late CollectionReference taskCollection;

  TaskRepository(FirebaseFirestore firebaseFirestore) {
    taskCollection = firebaseFirestore.collection('tasks');
  }

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

  Future<String> addTaskRepo(Map<String, dynamic> taskJson) async {
    var newDocRef = taskCollection.doc();
    taskJson['referenceId'] = newDocRef.id;
    await newDocRef.set(taskJson);
    return newDocRef.id;
  }

  Future<QuerySnapshot> fetchAllTasks() async {
    return await taskCollection.get();
  }
}

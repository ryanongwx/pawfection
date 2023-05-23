import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<List<Pet>> getPetList() async {
    QuerySnapshot snapshot = await petcollection.get();
    return snapshot.docs
        .map((doc) => Pet.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

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

  Future<List<Task>> getTaskList() async {
    QuerySnapshot snapshot = await taskcollection.get();
    return snapshot.docs
        .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

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

  Future<List<User>> getUserList() async {
    QuerySnapshot snapshot = await usercollection.get();
    return snapshot.docs
        .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

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

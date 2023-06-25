import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class PetRepository {
  final CollectionReference petCollection;

  // The factory method checks if a parameter is passed into the constructor or
  // not. By default, no parameter means the original DB is used.
  factory PetRepository([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;
    return PetRepository._internal(firestore.collection('pets'));
  }

  // PetRepository constructor
  PetRepository._internal(this.petCollection);

  Stream<QuerySnapshot> get pets {
    return petCollection.snapshots();
  }

  Future<void> addPetRepo(Map<String, dynamic> petJson) async {
    var newDocRef = petCollection.doc();
    petJson['referenceId'] = newDocRef.id;
    await newDocRef.set(petJson);
  }

  void updatePetRepo(Map<String, dynamic> taskJson, String? referenceId) async {
    await petCollection.doc(referenceId).update(taskJson);
  }

  void deletePetRepo(String? referenceId) async {
    await petCollection.doc(referenceId).delete();
  }

  Future<QuerySnapshot> fetchAllPets() async {
    return await petCollection.get();
  }
}

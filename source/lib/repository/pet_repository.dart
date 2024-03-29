import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class PetRepository {
  late CollectionReference petCollection;

  PetRepository(FirebaseFirestore firebaseFirestore) {
    petCollection = firebaseFirestore.collection('pets');
  }
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

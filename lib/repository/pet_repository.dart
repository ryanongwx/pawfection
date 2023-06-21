import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class PetRepository {
  final CollectionReference petCollection =
      FirebaseFirestore.instance.collection('pets');

  Stream<QuerySnapshot> get pets {
    return petCollection.snapshots();
  }

  Future<String> addPetRepo(Map<String, dynamic> petJson) async {
    var newDocRef = petCollection.doc();
    await newDocRef.set(petJson);
    return newDocRef.id;
  }

  void updatePetRepo(Map<String, dynamic> taskJson, String? referenceId) async {
    await petCollection
        .doc(referenceId)
        .update(taskJson);
  }

  void deletePetRepo(String? referenceId) async {
    await petCollection.doc(referenceId).delete();
  }

  Future<QuerySnapshot> fetchAllPets() async {
    return await petCollection.get();
  }
}

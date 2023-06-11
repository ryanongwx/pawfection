import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/pet.dart';

class PetRepository {
  final CollectionReference petcollection =
  FirebaseFirestore.instance.collection('pets');

  Stream<QuerySnapshot> get pets {
    return petcollection.snapshots();
  }

  List<Pet> snapshotToPetList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
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

  List<Pet> snapshotToPetList_modified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
        as Map<String, dynamic>; // Cast to the correct data type
        return Pet.fromJson(data);
      }).toList();
    }
  }

  Future<Pet?> findUserByPetID(String referenceId) async {
    final querySnapshot = await petcollection.get();
    final petList = snapshotToPetList_modified(querySnapshot);

    for (Pet pet in petList) {
      if (pet.referenceId == referenceId) {
        return pet;
      }
    }

    return null;
  }
}
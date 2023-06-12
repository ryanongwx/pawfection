import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/service/pet_service.dart';
import 'dart:async';

import '../models/pet.dart';

class PetRepository {
  final CollectionReference petcollection =
      FirebaseFirestore.instance.collection('pets');
  final petService = PetService();

  Stream<QuerySnapshot> get pets {
    return petcollection.snapshots();
  }

  // Future<List<Pet>> getPetList() async {
  //   QuerySnapshot snapshot = await petcollection.get();
  //   return snapshot.docs
  //       .map((doc) => Pet.fromJson(doc.data() as Map<String, dynamic>))
  //       .toList()
  //       .cast();
  // }

  Future<void> addPet(Pet pet) {
    var newDocRef = petcollection.doc();
    pet.referenceId = newDocRef.id;
    return newDocRef.set(petService.petToJson(pet));
  }

  void updatePet(Pet pet) async {
    await petcollection.doc(pet.referenceId).update(petService.petToJson(pet));
  }

  void deletePet(Pet pet) async {
    await petcollection.doc(pet.referenceId).delete();
  }

  Future<Pet?> findUserByPetID(String referenceId) async {
    final querySnapshot = await petcollection.get();
    final petList = petService.snapshotToPetList_modified(querySnapshot);

    for (Pet pet in petList) {
      if (pet.referenceId == referenceId) {
        return pet;
      }
    }

    return null;
  }

  Future<Pet?> findPetByPetID(String referenceId) async {
    final querySnapshot = await petcollection.get();
    final petList = petService.snapshotToPetList_modified(querySnapshot);

    for (Pet pet in petList) {
      if (pet.referenceId == referenceId) {
        return pet;
      }
    }

    return null;
  }

  Future<List<Pet>> getPetList() async {
    QuerySnapshot snapshot = await petcollection.get();
    return snapshot.docs
        .map((doc) => petService.petFromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

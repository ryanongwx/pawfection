import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/repository/pet_repository.dart';

import '../models/pet.dart';

class PetService {
  PetRepository petRepository = PetRepository();

  Pet petFromJson(Map<String, dynamic> json) => Pet(json['name'] as String,
      breed: json['breed'] as String?,
      referenceId: json['referenceId'] as String,
      description: json['description'] as String?,
      thingstonote: json['thingstonote'] as String?,
      profilepicture: json['profilepicture'] as String);

  Map<String, dynamic> petToJson(Pet instance) => <String, dynamic>{
        'name': instance.name.toLowerCase(),
        'breed': instance.breed,
        'referenceId': instance.referenceId,
        'description': instance.description,
        'thingstonote': instance.thingstonote,
        'profilepicture': instance.profilepicture,
      };

  Pet fromSnapshot(DocumentSnapshot snapshot) {
    final newPet = petFromJson(snapshot.data() as Map<String, dynamic>);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  List<Pet> snapshotToPetList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return petFromJson(data);
      }).toList();
    }
  }

  List<Pet> snapshotToPetListModified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
            as Map<String, dynamic>; // Cast to the correct data type
        return petFromJson(data);
      }).toList();
    }
  }

  void updatePet(Pet pet) async {
    petRepository.updatePetRepo(petToJson(pet), pet.referenceId);
  }

  void deletePet(Pet pet) {
    petRepository.deletePetRepo(pet.referenceId);
  }

  Future<void> addPet(Pet pet) async {
    var petJson = petToJson(pet);
    var refId = await petRepository.addPetRepo(petJson);
    pet.referenceId = refId;
  }

  Future<Pet?> findPetByPetID(String referenceId) async {
    final snapshot = await petRepository.fetchAllPets();
    final pets = snapshotToPetListModified(snapshot);

    for (Pet pet in pets) {
      if (pet.referenceId == referenceId) {
        return pet;
      }
    }

    return null;
  }

  Future<List<Pet>> getPetList() async {
    QuerySnapshot snapshot = await petRepository.fetchAllPets();
    return snapshot.docs
        .map((doc) => petFromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

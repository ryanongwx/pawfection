import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/pet.dart';

class PetService {
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

  List<Pet> snapshotToPetList_modified(QuerySnapshot<Object?> snapshot) {
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
}

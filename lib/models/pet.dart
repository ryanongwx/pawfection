import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String? referenceId;
  String name;
  String? breed;
  String? description;
  String? thingstonote;
  String profilepicture;

  Pet(this.name,
      {this.referenceId,
      this.breed,
      this.description,
      this.thingstonote,
      required this.profilepicture});

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    final newPet = Pet.fromJson(snapshot.data() as Map<String, dynamic>);
    newPet.referenceId = snapshot.reference.id;
    return newPet;
  }

  factory Pet.fromJson(Map<String, dynamic> json) => _petFromJson(json);

  Map<String, dynamic> toJson() => _petToJson(this);

  @override
  String toString() => 'Pet<$name>';
}

// _userFromJson turns a map of values from Firestore into a User class.

Pet _petFromJson(Map<String, dynamic> json) {
  return Pet(json['name'] as String,
      breed: json['breed'] as String?,
      description: json['description'] as String?,
      thingstonote: json['thingstonote'] as String?,
      profilepicture: json['profilepicture'] as String);
}

Map<String, dynamic> _petToJson(Pet instance) => <String, dynamic>{
      'name': instance.name.toLowerCase(),
      'breed': instance.breed,
      'description': instance.description,
      'thingstonote': instance.thingstonote,
      'profilepicture': instance.profilepicture,
    };

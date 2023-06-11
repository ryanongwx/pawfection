import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/user.dart';

class UserService {
  // _userFromJson turns a map of values from Firestore into a User class.
  User userFromJson(Map<String, dynamic> json) {
    return User(json['email'] as String,
        referenceId: json['referenceId'] as String,
        bio: json['bio'] as String,
        username: json['username'] as String,
        role: json['role'] as String,
        availabledates:
        json['availabledates'].cast<Timestamp?>() as List<Timestamp?>,
        preferences: json['preferences'].cast<String?>() as List<String?>,
        experiences: json['experiences'].cast<String?>() as List<String?>,
        profilepicture: json['profilepicture'] as String,
        contactnumber: json['contactnumber'] as String);
  }

  Map<String, dynamic> userToJson(User instance) => <String, dynamic>{
    'username': instance.username.toLowerCase(),
    'referenceId': instance.referenceId,
    'bio': instance.bio,
    'email': instance.email,
    'role': instance.role,
    'availabledates': instance.availabledates,
    'preferences': instance.preferences,
    'experiences': instance.experiences,
    'profilepicture': instance.profilepicture,
    'contactnumber': instance.contactnumber,
  };

  User fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = userFromJson(snapshot.data() as Map<String, dynamic>);
    newUser.referenceId = snapshot.reference.id;
    return newUser;
  }

  List<User> snapshotToUserList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return userFromJson(data);
      }).toList();
    }
  }

  List<User> snapshotToUserList_modified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
        as Map<String, dynamic>; // Cast to the correct data type
        return userFromJson(data);
      }).toList();
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  String referenceId;
  String username;
  String email;
  String role;
  List<Timestamp?> availabledates;
  List<String?> preferences;
  List<String?> experiences;
  String profilepicture;
  String contactnumber;
  String bio;

  User(this.email,
      {required this.referenceId,
      required this.username,
      required this.role,
      required this.availabledates,
      required this.preferences,
      required this.experiences,
      required this.profilepicture,
      required this.contactnumber,
      required this.bio});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.referenceId = snapshot.reference.id;
    return newUser;
  }

  factory User.fromJson(Map<String, dynamic> json) => _userFromJson(json);

  Map<String, dynamic> toJson() => _userToJson(this);

  @override
  String toString() => 'User<$username>';
}

// _userFromJson turns a map of values from Firestore into a User class.

User _userFromJson(Map<String, dynamic> json) {
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

Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
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

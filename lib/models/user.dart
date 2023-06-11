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

  @override
  String toString() => 'User<$username>';
}

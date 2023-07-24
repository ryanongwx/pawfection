import 'package:cloud_firestore/cloud_firestore.dart';

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
  int taskcount;

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
      required this.bio,
      required this.taskcount});

  // Overrides == of users
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.referenceId == referenceId;
  }

  @override
  int get hashCode => referenceId.hashCode;

  @override
  String toString() => 'User<$username>';
}

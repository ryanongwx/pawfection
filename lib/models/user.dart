import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? referenceId;
  String username;
  String email;
  String role;
  List<Timestamp>? availabledates;
  List<String>? preferences;
  List<String>? experiences;
  String profilepicture;
  String contactnumber;

  User(this.email,
      {this.referenceId,
      required this.username,
      required this.role,
      this.availabledates,
      this.preferences,
      this.experiences,
      required this.profilepicture,
      required this.contactnumber});

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
      username: json['username'] as String,
      role: json['role'] as String,
      availabledates: json['availabledates'] as List<Timestamp>?,
      preferences: json['preferences'] as List<String>?,
      experiences: json['experiences'] as List<String>?,
      profilepicture: json['profilepicture'] as String,
      contactnumber: json['contactnumber'] as String);
}

Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'availabledates': instance.availabledates,
      'preferences': instance.preferences,
      'experiences': instance.experiences,
      'profilepicture': instance.profilepicture,
      'contactnumber': instance.contactnumber,
    };

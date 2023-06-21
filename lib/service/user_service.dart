import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/repository/user_repository.dart';
import '../models/user.dart';

class UserService {
  UserRepository userRepository = UserRepository();

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

  List<User> snapshotToUserListModified(QuerySnapshot<Object?> snapshot) {
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

  void updateUser(User user) async {
    userRepository.updateUserRepo(userToJson(user), user.referenceId);
  }

  void deleteUser(User user) {
    userRepository.deleteUserRepo(user.referenceId);
  }

  void addUser(User user) {
    var userJson = userToJson(user);
    userRepository.addUserRepo(userJson, user.referenceId);
  }

  Future<List<User>> getUserList() async {
    QuerySnapshot snapshot = await userRepository.fetchAllUsers();
    return snapshot.docs
        .map((doc) => userFromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<User?> findUserByUUID(String referenceId) async {
    final querySnapshot = await userRepository.fetchAllUsers();
    final userList = snapshotToUserListModified(querySnapshot);

    for (User user in userList) {
      if (user.referenceId == referenceId) {
        return user;
      }
    }

    return null;
  }

  Future<List<User?>> findUserByUUIDs(List<String?> referenceIds) async {
    final querySnapshot = await userRepository.fetchAllUsers();
    final userList = snapshotToUserListModified(querySnapshot);

    List<User> result = [];

    for (User user in userList) {
      if (referenceIds.contains(user.referenceId)) {
        result.add(user);
      }
    }

    return result;
  }

  Future<User?> findUserByUsername(String username) async {
    final querySnapshot = await userRepository.fetchAllUsers();
    final userList = snapshotToUserListModified(querySnapshot);

    for (User user in userList) {
      if (user.username == username) {
        return user;
      }
    }

    return null;
  }

  // Returns User object
  Future<User?> currentUser(auth) async {
    var user = auth.currentUser;
    if (user != null) {
      return await findUserByUUID(user.uid);
    } else {
      return null;
    }
  }
}

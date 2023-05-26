import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';

class Task {
  String? referenceId;
  String name;
  String createdby;
  String assignedto;
  String description;
  String status;
  List<String?> resources;
  String contactperson;
  String contactpersonnumber;
  String? feedback;
  List<DateTime?> deadline;
  String pet;

  Task(
    this.name, {
    this.referenceId,
    required this.createdby,
    required this.assignedto,
    required this.description,
    required this.status,
    required this.resources,
    required this.contactperson,
    required this.contactpersonnumber,
    this.feedback,
    required this.deadline,
    required this.pet,
  });

  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    final newTask = Task.fromJson(snapshot.data() as Map<String, dynamic>);
    newTask.referenceId = snapshot.reference.id;
    return newTask;
  }

  factory Task.fromJson(Map<String, dynamic> json) => _taskFromJson(json);

  Map<String, dynamic> toJson() => _taskToJson(this);

  @override
  String toString() => 'Task<$name>';
}

// _userFromJson turns a map of values from Firestore into a User class.

Task _taskFromJson(Map<String, dynamic> json) {
  return Task(json['name'] as String,
      assignedto: json['assignedto'] as String,
      createdby: json['createdby'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      resources: json['resources'].cast<String?>() as List<String?>,
      contactperson: json['contactperson'] as String,
      contactpersonnumber: json['contactpersonnumber'] as String,
      feedback: json['feedback'] as String?,
      deadline: json['deadline'].cast<DateTime?>() as List<DateTime?>,
      pet: json['pet'] as String);
}

Map<String, dynamic> _taskToJson(Task instance) => <String, dynamic>{
      'name': instance.name.toLowerCase(),
      'createdby': instance.createdby,
      'assignedto': instance.assignedto,
      'description': instance.description,
      'status': instance.status,
      'resources': instance.resources,
      'contactperson': instance.contactperson,
      'contactpersonnumber': instance.contactpersonnumber,
      'feedback': instance.feedback,
      'deadline': instance.deadline,
      'pet': instance.pet,
    };

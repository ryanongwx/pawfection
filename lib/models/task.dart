import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';

class Task {
  String? referenceId;
  String name;
  User createdby;
  User assignedto;
  String description;
  String status;
  List<String>? resources;
  User contactperson;
  String contactpersonnumber;
  String? feedback;
  List<Timestamp> deadline;
  Pet pet;

  Task(this.name,
      {this.referenceId,
      required this.createdby,
      required this.assignedto,
      required this.description,
      required this.status,
      this.resources,
      required this.contactperson,
      required this.contactpersonnumber,
      this.feedback,
      required this.deadline,
      required this.pet});

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
      assignedto: json['assignedto'] as User,
      createdby: json['createdby'] as User,
      description: json['description'] as String,
      status: json['status'] as String,
      resources: json['resources'] as List<String>?,
      contactperson: json['contactperson'] as User,
      contactpersonnumber: json['contactpersonnumber'] as String,
      feedback: json['feedback'] as String?,
      deadline: json['deadline'] as List<Timestamp>,
      pet: json['pet'] as Pet);
}

Map<String, dynamic> _taskToJson(Task instance) => <String, dynamic>{
      'name': instance.name,
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

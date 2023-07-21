import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? referenceId;
  String name;
  String createdby;
  String? assignedto;
  String description;
  String category;
  String? categoryothers;
  String status;
  List<String?> resources;
  String contactperson;
  String contactpersonnumber;
  String? feedback;
  List<Timestamp?> deadline;
  String? pet;
  List<String?> requests;

  Task(
    this.name, {
    this.referenceId,
    required this.createdby,
    this.assignedto,
    required this.description,
    required this.category,
    this.categoryothers,
    required this.status,
    required this.resources,
    required this.contactperson,
    required this.contactpersonnumber,
    this.feedback,
    required this.requests,
    required this.deadline,
    this.pet,
  });

  @override
  String toString() => 'Task<$name>';
}

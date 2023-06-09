import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';

class Task {
  String? referenceId;
  String name;
  String createdby;
  String? assignedto;
  String description;
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

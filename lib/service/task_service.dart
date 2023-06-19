import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/task.dart';

class TaskService {
  // _userFromJson turns a map of values from Firestore into a User class.

  Task taskFromJson(Map<String, dynamic> json) {
    return Task(json['name'] as String,
        referenceId: json['referenceId'] as String,
        assignedto: json['assignedto'] as String?,
        createdby: json['createdby'] as String,
        description: json['description'] as String,
        status: json['status'] as String,
        resources: json['resources'].cast<String?>() as List<String?>,
        contactperson: json['contactperson'] as String,
        contactpersonnumber: json['contactpersonnumber'] as String,
        feedback: json['feedback'] as String?,
        deadline: json['deadline'].cast<Timestamp?>() as List<Timestamp?>,
        pet: json['pet'] as String);
  }

  Map<String, dynamic> taskToJson(Task instance) => <String, dynamic>{
        'name': instance.name.toLowerCase(),
        'createdby': instance.createdby,
        'referenceId': instance.referenceId,
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

  Task fromSnapshot(DocumentSnapshot snapshot) {
    final newTask = taskFromJson(snapshot.data() as Map<String, dynamic>);
    newTask.referenceId = snapshot.reference.id;
    return newTask;
  }

  List<Task> snapshotToTaskList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data == null) {
      return [];
    } else {
      return snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return taskFromJson(data);
      }).toList();
    }
  }

  List<Task> snapshotToTaskList_modified(QuerySnapshot<Object?> snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    } else {
      return snapshot.docs.map((DocumentSnapshot<Object?> document) {
        Map<String, dynamic> data = document.data()
            as Map<String, dynamic>; // Cast to the correct data type
        return taskFromJson(data);
      }).toList();
    }
  }
}
